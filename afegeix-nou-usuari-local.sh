#https://github.com/Mariogg1/afegeix-nou-usuari-local
#!/bin/bash

# 1- Make sure the script is being executed with superuser privileges.
    #Veure que l'exercici, s'executa amb privilegis d'usuari
if [[ "${UID}" -ne 0 ]]
    then
        echo 'Only with root or sudo.' >&2
    exit 1
fi

# 2- If the user don't supply at least one argument, then give them help.
    #Posarmissatges per a que l'usuari ompli tots els camps
if [[ "${#}" -lt 1 ]]
    then
        echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
        echo 'Create an account on the local system with the name of USER_NAME and a comments field of COMMENT.' >&2
    exit 1
fi

# 3- The first parameter is the user name.
    #Aquesta linea de codi serveix per a que el nom d'usuari sigui el primer parametre 
USER_NAME="${1}"

# 4- The rest of the parameters are for the accout comments.
    #El altres parametres son dels comentaris
shift
COMMENT="${@}"

# 5- Generate a password.
    #Genera una password de 10 caracters aleatoriament entre numero i lletres
PASSWORD=$(date +%s%N | sha256sum | head -c10)

# 6- Create the user with the password.
    #Crear un usuari mitjançant la contrasenya
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# 7- Check to see if the useradd command succeeded.
    #Serveix per veure que el useradd ha sortit bé
if [[ "${?}" -ne 0 ]]
    then
        echo 'No se a creado la cuenta.' >&2
    exit 1
fi

# 8- Set the password.
    #Guarda la contrasenya
    #Aquesta funció crec que no està bé del tot
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# 9- Check to see if the passwd command succeeded.
    #Serveix per veure que la password s'ha guardat bé
if [[ "${?}" -ne 0 ]]
    then
        echo 'La contrasenya no se ha guardat.' >&2
    exit 1
fi

# 10- Force password change on first login.
    #Amb el primer inicide sessió es força la contrasenya
passwd -e ${USER_NAME} &> /dev/null

# 11- Display the username, password, and the host where the user was created.
    #Quan acaba fa un recompte i mostra per pantalla en nom d'usuari, la password i el host
    #El host no el mostra bé, hem dona error

echo 'Nom de usuari: '
echo "${USER_NAME}"
echo 'Contrasenya: '
echo "${PASSWORD}"
echo 'Host: '
echo "${HOSTNAME}"
exit 0
