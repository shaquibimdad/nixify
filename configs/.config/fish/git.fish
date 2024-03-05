function gac
  git add .
  git commit --amend --no-edit
  git push -f
end

function capgh
    if not command -v gh >/dev/null
        echo "GitHub CLI (gh) is not installed. Please install it: https://cli.github.com/"
        return 1
    end

    # Check if folder name is provided
    if test (count $argv) -eq 0
        echo "Please provide the folder name as an argument."
        return 1
    end

    set folder_name $argv[1]

    # Check if the folder exists
    if not test -d $folder_name
        echo "Folder '$folder_name' does not exist."
        return 1
    end

    # Initialize a new Git repository in the folder
    cd $folder_name
    git init

    # Create a new GitHub repository using gh
    gh repo create $folder_name --private --confirm

    # Add the GitHub remote URL to the local Git repository
    set github_url (gh repo view --json "clone_url" -q ".clone_url")
    git remote add origin $github_url

    # Add all files, commit, and push to the new repository
    git add .
    git commit -m "Initial commit"
    git push -u origin main

    echo "New GitHub repository '$folder_name' created and files pushed."
end
