import numpy as np
import matplotlib.pyplot as plt


def generateSingleSinusoid(img_size, angle, ncycles, phase):
    angle = np.radians(angle)
    sinepath = (np.linspace(0, 2, img_size))[:,np.newaxis].repeat(img_size,axis=1)
    sinusoid = (sinepath*np.sin(angle) + sinepath.T*np.cos(angle)) * ncycles * np.pi # number of cycles
    sinusoid = np.sin(sinusoid + phase)
    return sinusoid


def generatePatches(img_size, nscale=5, ncycles=2):
    scales = [2**i for i in range(1,nscale+1)]
    NumPatch = [(scale/2)**2 for scale in scales]
    patches = {}

    for scale,numpatch in zip(scales,NumPatch):
        length = int(scale/2)
        patch_size = img_size // length
        angle = [0, 30, 60, 90, 120, 150]
        phases = [0, np.pi / 2]
        sinusoid_combined = []

        for p in phases:
            for a in angle:
                sinusoid = generateSingleSinusoid(patch_size, a, ncycles, p)
                sinusoid_combined.append(sinusoid)
        patch = np.array(sinusoid_combined)
        patch = np.tile(patch, (1, length, length))
        patches[scale] = patch

    return patches


def generateNoise(img_size, patches, nscale=5):

    scales = [2**i for i in range(1,nscale+1)]
    NumPatch = [(scale / 2) ** 2 for scale in scales]
    NumParam = [int(num*12) for num in NumPatch]
    params = {}
    store_amplitude = {}

    for scale, numpatch, numpara in zip(scales,NumPatch,NumParam):
        length = int(scale/2)
        patch_size = img_size / length
        param = np.random.uniform(-1, 1, size=numpara) # here introduce amplitude
        # param = np.array([1] * numpara)

        # # visualize the params generated, to check the distribution
        # plt.hist(param, bins=30, edgecolor='black')
        # plt.title('Uniform Distribution Sample')
        # plt.xlabel('Value')
        # plt.ylabel('Frequency')
        # plt.grid(True)
        # plt.show()

        param_n = param.reshape((12, length, length))
        param_n = param_n.repeat(patch_size, axis=1).repeat(patch_size,axis=2)
        params[scale] = param_n
        store_amplitude[scale] = param

    noise = [patches[scale] * params[scale] for scale in scales]
    noise_array = np.array(noise)
    noise_scales = np.sum(noise_array, axis=1) # axis = 1 return different scales(5, 512, 512)
    noise_final = np.sum(np.sum(noise_array, axis=0), axis=0)
    return noise_final, params, store_amplitude, noise_scales


all_ampli = {}
num_loops = 5
img_size = 512

for i in range(num_loops):
    patches = generatePatches(img_size, nscale=4, ncycles=1)
    noise, params, store_amplitude, noise_scales = generateNoise(img_size, patches, nscale=4)

    # save the parameters
    all_ampli[f'imageindex_{i}'] = store_amplitude
    # np.save(f'ampli_{i}.npy', store_amplitude)

    # save the noise image
    fig_size = 512
    ppi = 42  # inch
    fig_size_inches = fig_size / ppi
    fig, ax = plt.subplots(figsize=(fig_size_inches, fig_size_inches), dpi=ppi)
    plt.subplots_adjust(left=0, right=1, top=1, bottom=0)

    ax.imshow(noise, cmap='gray')
    ax.axis('off')  # Turn off the axis
    plt.savefig(f'image_{i}.png', dpi= ppi)
    plt.close()

np.save('all_amplitude.npy', all_ampli)
loaddata = np.load('all_amplitude.npy', allow_pickle=True)
print(loaddata)