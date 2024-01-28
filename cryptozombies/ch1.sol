
#! Chapter 1: Lesson Overview

# Build a Zombie Factory to build an army of zombies

# -Factory will maintain a database of all zombies in our army
# -Factory will have a function for creating new zombies
# -Each zombie will have a random and unique appearance

# Later we'll add more functionality, like giving zombies the ability to attack humans or other zombies.

#* Zombie DNA

# Zombie apperance based on 'Zombie DNA'. 16-digit integer:
    # ex. 8356281049284737
    # Diff. parts of this number map to different traits.
        # First 2 digits map to zombie's head type, 2nd 2 digits eyes, etc.

# First 2 digits in example DNA are 83. To map to zombie's head type, do 83 % 7 + 1 = 7. So this Zombie has the 7th zombie head type