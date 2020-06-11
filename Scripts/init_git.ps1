#!/snap/bin/powershell
#


$UserName   = read-host "Your full name: "
$UserEmail  = read-host "Your email address: "
$UserEditor = read-host "Your favorite editor (nano, vi, emacs): "

git config --global user.name $UserName
git config --global user.email $UserEmail
git config --global core.editor $UserEditor
echo "Done."
exit 0