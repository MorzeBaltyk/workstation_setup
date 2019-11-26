###### Functions to format Input/Ouput ######
function f-lower ()
{
echo $@ | tr '[:upper:]' '[:lower:]'
}

function f-upper ()
{
echo $@ | tr '[:lower:]' '[:upper:]'
}

