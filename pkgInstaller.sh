
pkgDirectory="$1"
errors=0
tryAgainMax=0

# Load functions
loadingFunction() {
    bash ./coolFunctions/loadingFunction.sh
}


main () {
for packageTXT in $(ls $pkgDirectory/*.txt); do

    tryAgainMax=5

    installCommand() {
        sudo pacman -Sy --needed --noconfirm $(cat $packageTXT)
    }
    sleep 1
    loadingFunction
    echo "Apps from $packageTXT package list will be installed."
    sleep .5


    while [ $tryAgainMax -gt 0 ]; do
        if installCommand; then
            echo "Installation of package from $packageTXT installed"
            tryAgainMax=0
            errors=0
            echo
        else
            tryAgainMax=$((tryAgainMax - 1))
            errors=$((errors + 1))
            if [[ $tryAgainMax != 0 ]]; then
                echo "Trying once more time"
            fi
        fi
            sleep 1
    done
done

if [ $errors -gt 0 ]; then
    echo "Installation Failed :("
    return 1
else
    echo "All packages from $pkgDirectory was installed :)"
    return 0
fi

}

main
