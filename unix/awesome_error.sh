errfile="${HOME}/.awesome-errors"
cp /dev/null "$errfile" 2> /dev/null
chmod 600 "$errfile"
exec > "$errfile" 2>&1
