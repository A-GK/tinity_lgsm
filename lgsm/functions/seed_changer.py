from random import randint
import sys


cfg_location = sys.argv[1]
seed_location = sys.argv[2]


def get_next_seed():
    try:
        seeds_cfg = open(seed_location, "r")
        seeds_cfg_lines = seeds_cfg.readlines()
        seeds_cfg.close()
        new_seed = int(seeds_cfg_lines.pop().replace("\n", ""))
    except Exception:
        new_seed = randint(1,2147483646)
    try:
        with open(seed_location, "w") as f:
            for item in seeds_cfg_lines:
                f.write(item)
    except Exception as e:
        print(f"An error occurred while removing seed from seeds.txt: {e}")
    return new_seed


def replace_seed(seed):
    try:
        server_cfg = open(cfg_location, "r")
        server_cfg_lines = server_cfg.readlines()
        server_cfg.close()
        new_cfg = []
        modified_seed = False

        for line in server_cfg_lines:
            if "seed" in line:
                modified_seed = True
                line = f'seed "{seed}" \n'
            new_cfg.append(line)
        
        # In case there's no "seed" option in the config, append it
        if not modified_seed:
            new_cfg.append(f'\nseed "{seed}" \n')

        with open(cfg_location, "w") as f:
            for item in new_cfg:
                f.write(item)
    except Exception as e:
        print(f"An error occurred while setting the seed: {e}")

new_seed = get_next_seed()
print(f"Changing seed to {new_seed}")
replace_seed(new_seed)