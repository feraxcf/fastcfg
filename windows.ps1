## Directory creation
$baseDir = "$HOME\projects"

$directories = @(
    "$baseDir\pprojects",
    "$baseDir\tprojects",
    "$baseDir\temp"
)

foreach ($directory in $directories) {
    if (!(Test-Path -Path $directory -PathType Container)) {
        Write-Host "Creating directory: $directory"
        New-Item -ItemType Directory -Path $directory
    } else {
        Write-Host "Directory already exists: $directory"
    }
}

Write-Host "Directory creation complete."

## Install Aplications

Write-Host "Installing Git and OhMyPosh using winget..."

# Install Git
try {
    winget install --id Git.Git -e --source winget
    Write-Host "Git installed successfully."

    # Refresh environment variables after Git installation
    Write-Host "Refreshing environment variables after Git installation..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

}
catch {
    Write-Host "Error installing Git: $($_.Exception.Message)"
}

# Install OhMyPosh
try {
    winget install --id JanDeDobbeleer.OhMyPosh -e --source winget
    Write-Host "OhMyPosh installed successfully."
}
catch {
    Write-Host "Error installing OhMyPosh: $($_.Exception.Message)"
}

Write-Host "Software installation complete."

## Clone repositories

Write-Host "Cloning Git repositories..."

# Define the repositories to clone
$repositories = @(
    @{ url = "https://github.com/feraxcf/.glzr"; destination = "$HOME\.glzr" },
    @{ url = "https://github.com/feraxcf/.fx"; destination = "$HOME\.fx" },
    @{ url = "https://github.com/feraxcf/zed"; destination = "$env:APPDATA\Zed" }
)

# Loop through the repositories and clone them
foreach ($repository in $repositories) {
    $url = $repository.url
    $destination = $repository.destination

    Write-Host "Cloning $url to $destination..."

    try {
        # Ensure git is available by checking its version
        git --version | Out-Null

        git clone $url $destination
        Write-Host "Successfully cloned $url to $destination."
    }
    catch {
        Write-Host "Error cloning $url: $($_.Exception.Message)"
    }
}

Write-Host "Git cloning complete."

# .bashrc
Write-Host "Creating .bashrc file..."

$bashrcPath = "$HOME\.bashrc"
$sourceFilePath = "$HOME\.fx\bash\bash.shell"

try {
    # Check if the source file exists
    if (Test-Path -Path $sourceFilePath -PathType Leaf) {
        # Read the content of the source file
        $content = Get-Content -Path $sourceFilePath -Raw

        # Write the content to the .bashrc file
        Set-Content -Path $bashrcPath -Value $content

        Write-Host "Successfully created .bashrc file with content from $sourceFilePath"
    } else {
        Write-Host "Error: Source file not found: $sourceFilePath"
    }
}
catch {
    Write-Host "Error creating .bashrc file: $($_.Exception.Message)"
}

Write-Host ".bashrc creation complete."
