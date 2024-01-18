import shutil
import sys
import os
from shutil import copytree, ignore_patterns
from subprocess import check_output

version = "1.4.5"
type = "release"

addon_name = "Kui_Nameplates_TargetHelper"
short_name = "Kui TargetHelper"
staging_folder_name = "build"

def create_staging_folder(folder_name):
    if not os.path.exists(folder_name):
        # Create the new folder
        os.mkdir(folder_name)
        print(f"Folder '{folder_name}' created successfully.")
    else:
        print(f"Folder '{folder_name}' already exists.")

def cleanup_staging_folder(folder_name):
    shutil.rmtree(folder_name)

def copy_to_staging_folder(addon_name, folder_name):
    outdir = os.path.join(folder_name, addon_name)
    copytree(addon_name, outdir, ignore=ignore_patterns('*.json', '.vscode'))

def update_version(addon_name, staging_folder_name, version):
    
    # Read the contents of the file
    try:
        file_name = os.path.join(staging_folder_name, addon_name, "config.lua")
        with open(file_name, "r") as file:
            file_contents = file.read()

        # replace version
        modified_contents = file_contents.replace("<VERSION>", version)

        # Write the modified contents back to the file
        with open(file_name, "w") as file:
            file.write(modified_contents)
    except:
        print('failed to update version')

def create_github_release(file_name):
    try:
        check_output(["gh", "release", "create", "--title", f"Release v{version}", "--generate-notes", f"v{version}", f"{file_name}"])
        print(f'Successfully created github release')
    except:
        print(f'Unable to create github release')
    
def main():

    try:

        # ensure local path is set
        current_dir = os.path.dirname(os.path.abspath(__file__))
        os.chdir(current_dir)

        # copy files to staging folder
        create_staging_folder(staging_folder_name)
        copy_to_staging_folder(addon_name, staging_folder_name)
        update_version(addon_name, staging_folder_name, version)

        # remove existing zip file
        zip_file = f"{short_name}_{version}_{type}"
        if os.path.isfile(zip_file):
            os.remove(zip_file)

        # generate new zip file
        shutil.make_archive(zip_file, 'zip', root_dir=staging_folder_name)

        # create github release
        create_github_release(zip_file + ".zip")

    except:
        pass
    finally:
        cleanup_staging_folder(staging_folder_name)

if __name__ == "__main__":
    main()

