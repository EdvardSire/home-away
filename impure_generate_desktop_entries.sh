location="$HOME/.local/share/applications"
entries=("sioyek" "QGroundControl")

mkdir -p "$location"

for entry in "${entries[@]}"; do
    cat <<EOF > "$location/$entry.desktop"
[Desktop Entry]
Type=Application
Name=$entry
Exec=$entry
EOF
done
