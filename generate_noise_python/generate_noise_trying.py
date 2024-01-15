import numpy as np
import matplotlib.pyplot as plt


def generateSingleSinusoid(img_size, angle, ncycles, phase):
    angle = np.radians(angle)
    sinepath = (np.linspace(0, 2, img_size))[:,np.newaxis].repeat(img_size,axis=1)
    sinusoid = (sinepath*np.sin(angle) + sinepath.T*np.cos(angle)) * ncycles * np.pi # number of cycles
    sinusoid = np.sin(sinusoid + phase)
    return sinusoid

def generateMultipleSinusoid(img_size, ncycles, R):
    patchs = []
    angles = [0, 30, 60, 90, 120, 150]
    phases = [0, np.pi / 2]
    for angle in angles:
        for phase in phases:
            img = generateSingleSinusoid(img_size, angle, ncycles, phase)
            patchs.append(img)
    sum = R[0] * patchs[0]
    for i in range(1,12):
        sum += R[i] * patchs[i]
    sum = sum/12
    return sum

img_size = 512
ncycles = 1
scale = 5
img = np.zeros((img_size,img_size))

for i in range(scale):
    R = [np.random.uniform(low=-1.0, high=1.0) for j in range(12)]
    img += generateMultipleSinusoid(img_size, (i+1)*ncycles, R)

img = img - img.min()
img = (img/img.max())*2
img = img - 1

plt.imshow(img, cmap='gray')
plt.show()