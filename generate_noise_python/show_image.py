import pygame
import os
import random
import time

# Initialize Pygame
pygame.init()

# Get the current display resolution
info = pygame.display.Info()
screen_width, screen_height = info.current_w, info.current_h

# Set up the screen in full-screen mode
screen = pygame.display.set_mode((screen_width, screen_height), pygame.FULLSCREEN)

# # Screen dimensions
# screen_width, screen_height = 1280, 800
# # Set up the screen
# screen = pygame.display.set_mode((screen_width, screen_height))

# Colors
grey = (128, 128, 128)
white = (255, 255, 255)
black = (0, 0, 0)

# Initialize the list for recording the image order and display time
image_order_and_time = []

# Record the start time of the experiment
experiment_start_time = time.time()

# press 'p' quit the program
def check_for_quit():
    for event in pygame.event.get():
        if event.type == pygame.KEYDOWN and event.key == pygame.K_p:
            pygame.quit()
            quit()

# if needed.
def take_snapshot(filename):
    pygame.image.save(screen, filename)

# Function to show the wait screen
def show_wait_screen():
    screen.fill(grey)
    pygame.draw.rect(screen, white, [screen_width-150, screen_height-100, 150, 100]) # down-right corner
    pygame.display.update()
    waiting = True
    while waiting:
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_s:
                    waiting = False

# Function to show the initialize screen
def show_init_screen():
    screen.fill(grey)
    pygame.draw.rect(screen, white, [screen_width-150, screen_height-100, 150, 100])
    pygame.display.update()
    start_time = time.time()
    while time.time() - start_time < 30: # duration
        check_for_quit()

# Function to show the ISI screen
def show_isi_screen():
    screen.fill(grey)
    pygame.draw.rect(screen, white, [screen_width-150, screen_height-100, 150, 100])
    pygame.display.update()
    start_time = time.time()
    while time.time() - start_time < 5:
        check_for_quit()

# Function to show the image
def show_image(image_path):
    current_time = time.time() - experiment_start_time
    image_present = pygame.image.load(image_path)
    scaled_width = screen_width # adjust the image size if needed
    scaled_height = screen_width # adjust the image size if needed
    image_present = pygame.transform.scale(image_present, (scaled_width, scaled_height)) # adjust the presented image
    screen.fill(grey)

    # Calculating position to center the image
    x_position = (screen_width - scaled_width) // 2
    y_position = (screen_height - scaled_height) // 2

    screen.blit(image_present, (x_position, y_position)) # (0,0) from the top-left
    pygame.draw.rect(screen, black, [screen_width-150, screen_height-100, 150, 100])
    pygame.display.update()

    # image_order_and_time.append((image_path, current_time))

    # Write to file immediately after displaying the image
    with open('image_order_and_time.txt', 'a') as file:
        file.write(f"{image_path}, {current_time:.2f} seconds\n")


    # # Take a snapshot after displaying the image
    # snapshot_filename = f"snapshots/snapshot_{time.strftime('%Y%m%d%H%M%S')}.png"
    # take_snapshot(snapshot_filename)

    start_time = time.time()
    while time.time() - start_time < 1:
        check_for_quit()


# Load all images from the specified directory
image_directory = 'D:/PycharmProjects/NoisePattern_Mouse/stimuli_manipulation/images_2cycle_4scale'  # Replace with the path to different image folder
image_files = [os.path.join(image_directory, file) for file in os.listdir(image_directory)
               if file.endswith(('.png'))]

# Main experiment loop
show_wait_screen()
show_init_screen()

while image_files:
    show_isi_screen()
    image_path = random.choice(image_files)
    show_image(image_path)
    image_files.remove(image_path)

show_isi_screen()

# # Save the image order to a file after the experiment
# with open('image_order_and_time.txt', 'w') as file:
#     for image, display_time in image_order_and_time:
#         file.write(f"{image}, {display_time:.2f} seconds\n")

pygame.quit()
