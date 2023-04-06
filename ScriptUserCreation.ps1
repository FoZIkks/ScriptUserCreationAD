# Script Création Utilisateurs pour l'AD
# Version 0.1
# Crée par Eazon


#--------------------------------------

# Changelog :
# V0.5 : Rédaction du script pour ajout d'utilisateurs dans l'AD
# V0.6 : Ajout d'un système de génération de mo tde passe aléatoire a partir de listes de mots
# V0.7 : Ajout d'une fonctionnalité de fenêtre
# V0.8 : Ajout de copie des groupes d'un utilisateurs
# V0.9 : Automatisation de l'ajout des informations d'utilisateur
# V1.0 : Finalisation et optimation 

#--------------------------------------

# Déclaration des fonctions

function GenerateRandomPassword {

    # Déclaration des listes contenant des mots qui seront choisis et assemblés au hasard
        
    [String[]]$passwordPrincipalName = "Orange", "Hypromat", "Elephant"
    [String[]]$passwordSecondName = "pass", "pom", "ter", "bis", "plu"
    [String[]]$passwordSpecialCaracter = "$", "!", "&", "@!", "/"
    $passwordNumber = Get-Random -Maximum 1000

    # Génération du mot de passe

    $Global:passwordUser = ($passwordPrincipalName[(Get-Random -Maximum $passwordPrincipalName.Length)]+(Get-Random -Maximum 1000)+$passwordSecondName[(Get-Random -Maximum $passwordSecondName.Length)]+$passwordSpecialCaracter[(Get-Random -Maximum $passwordSpecialCaracter.Length)])
    
}


# Construction de la fenêtre

Add-Type -AssemblyName System.Windows.Forms

$CreateUserADForm = New-Object system.Windows.Forms.Form

#Création de la fenêtre
$CreateUserADForm.ClientSize         = '500,450'
$CreateUserADForm.text               = "Ajout d'un nouvel utilisateur - HYPROMAT"
$CreateUserADForm.BackColor          = "#ffffff"

$Titre                           = New-Object system.Windows.Forms.Label
$Titre.text                      = "Ajout d'un nouvel Utilisateur"
$Titre.AutoSize                  = $true
$Titre.width                     = 25
$Titre.height                    = 10
$Titre.location                  = New-Object System.Drawing.Point(20,20)
$Titre.Font                      = 'Microsoft Sans Serif,13'
$CreateUserADForm.Controls.Add($Titre)

#Formulaire nom
$LinePrenameUser                               = New-Object System.Windows.Forms.Label
$LinePrenameUser.Location                      = New-Object System.Drawing.Point(20,80)
$LinePrenameUser.Size                          = New-Object System.Drawing.Size(280,20)
$LinePrenameUser.Text                          = "Prénom de l'utilisateur"
$CreateUserADForm.Controls.Add($LinePrenameUser)

$BoxPrenameUser                      = New-Object system.Windows.Forms.TextBox
$BoxPrenameUser.Location             = New-Object System.Drawing.Point(20,100)
$BoxPrenameUser.Size                 = New-Object System.Drawing.Size(260,20)
$CreateUserADForm.Controls.Add($BoxPrenameUser)

#Formulaire prénom
$LineNameUser                               = New-Object System.Windows.Forms.Label
$LineNameUser.Location                      = New-Object System.Drawing.Point(20,140)
$LineNameUser.Size                          = New-Object System.Drawing.Size(280,20)
$LineNameUser.Text                          = "Nom de l'utilisateur"
$CreateUserADForm.Controls.Add($LineNameUser)

$BoxNameUser                      = New-Object system.Windows.Forms.TextBox
$BoxNameUser.Location             = New-Object System.Drawing.Point(20,160)
$BoxNameUser.Size                 = New-Object System.Drawing.Size(260,20)
$CreateUserADForm.Controls.Add($BoxNameUser)

#Formulaire poste
$LineTitleUser                               = New-Object System.Windows.Forms.Label
$LineTitleUser.Location                      = New-Object System.Drawing.Point(20,280)
$LineTitleUser.Size                          = New-Object System.Drawing.Size(280,20)
$LineTitleUser.Text                          = "Intitulé du poste"
$CreateUserADForm.Controls.Add($LineTitleUser)

$BoxTitleUser                      = New-Object system.Windows.Forms.TextBox
$BoxTitleUser.Location             = New-Object System.Drawing.Point(20,300)
$BoxTitleUser.Size                 = New-Object System.Drawing.Size(260,20)
$CreateUserADForm.Controls.Add($BoxTitleUser)

#Formulaire de séléction d'un utilisateur pour copier les groupes ainsi que l'OU, le service et le manageur
$LineGroupUser                               = New-Object System.Windows.Forms.Label
$LineGroupUser.Location                      = New-Object System.Drawing.Point(20,200)
$LineGroupUser.Size                          = New-Object System.Drawing.Size(280,40)
$LineGroupUser.Text                          = "Choisir un utilisateur sur lequel copier les groupes à attribuer au nouvel utilisateur :"
$CreateUserADForm.Controls.Add($LineGroupUser)
$ComboBox                       = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width                 = 300
$Users                          = get-aduser -filter * -Properties SamAccountName
Foreach ($User in $Users)
{

$ComboBox.Items.Add($User.SamAccountName);

}
$ComboBox.Location             = New-Object System.Drawing.Point(20,240)
$CreateUserADForm.Controls.Add($ComboBox)

#Bouton cancel
$cancelBtn                       = New-Object system.Windows.Forms.Button
$cancelBtn.BackColor             = "#ffffff"
$cancelBtn.text                  = "Annuler"
$cancelBtn.width                 = 90
$cancelBtn.height                = 30
$cancelBtn.location              = New-Object System.Drawing.Point(280,390)
$cancelBtn.Font                  = 'Microsoft Sans Serif,10'
$cancelBtn.ForeColor             = "#000"
$cancelBtn.DialogResult          = [System.Windows.Forms.DialogResult]::Cancel
$CreateUserADForm.CancelButton   = $cancelBtn
$CreateUserADForm.Controls.Add($cancelBtn)

#Bouton suivant
$nextBtn                       = New-Object system.Windows.Forms.Button
$nextBtn.BackColor             = "#ffffff"
$nextBtn.text                  = "Créer!"
$nextBtn.width                 = 90
$nextBtn.height                = 30
$nextBtn.location              = New-Object System.Drawing.Point(380,390)
$nextBtn.Font                  = 'Microsoft Sans Serif,10'
$nextBtn.ForeColor             = "#000"
$nextBtn.DialogResult          = [System.Windows.Forms.DialogResult]::OK
$CreateUserADForm.AcceptButton = $nextBtn
$nextBtn.Add_Click({

        # On récupère les entrées pour les transformer en variable
        Set-Variable -Name shortName -Value $BoxPrenameUser.text -Scope 1
        Set-Variable -Name longName -Value $BoxNameUser.text -Scope 1
        Set-Variable -Name SetUserTitle -Value $BoxTitleUser.text -Scope 1
		$CreateUserADForm.Close()
	})
$CreateUserADForm.Controls.Add($nextBtn)

# On définit le résultat des boutons

# Si on appuie sur le bouton "annuler" : on annule (logique)
$result = $CreateUserADForm.ShowDialog()
if ($result –eq [System.Windows.Forms.DialogResult]::Cancel)
{
    write-output 'Annulation de la procédure'
}

# Si on appuie sur le bouton "créer!", on lance la procédure de création (ca va, vous suivez?)
if ($result –eq [System.Windows.Forms.DialogResult]::OK)
{
    Write-Host 'Initialisation du processus de création'
    # On génère un mot de passe aléatoire
    GenerateRandomPassword
    Write-Host $passwordUser
    $passwordUser = convertto-securestring $passwordUser -asplaintext -force
    # On récupère quel utilisateur a été choisi pour être copié
    $NewUser = $shortName.ToLower()+'_'+$longName.Substring(0,1).ToLower()
    $selectedUser = $ComboBox.SelectedItem
    Write-Host $selectedUser
    $SelectedUserOU = (Get-ADUser -Identity $selectedUser -Properties DistinguishedName)
    $Groups = (Get-ADPrincipalGroupMembership -Identity $selectedUser).Name
    $userOU = ($SelectedUserOU.DistinguishedName -split ",",2)[1]
    Write-Host $userOU

    $UserDepartment = (Get-ADUser -Identity $selectedUser -Properties Department)
    $SetUserDepartment = ($UserDepartment.Department)

    $UserManager = (Get-ADUser -Identity $selectedUser -Properties Manager)
    $SetUserManager = ($UserManager.Manager)

    # On crée l'utilisateur a partir de toutes ces infos
    New-ADUser -Name ($shortName+" "+$longName) -GivenName ($shortName+" "+$longName) -DisplayName $shortName -Surname $longName -SamAccountName ($shortName.ToLower()+'_'+$longName.Substring(0,1).ToLower()) -UserPrincipalName ($shortName.ToLower()+"."+$longName.ToLower()+"@hypromat.com") -AccountPassword($passwordUser) -Enabled $true -Path $UserOU -Company $UserCompany -City $UserCity -EmailAddress ($shortName.ToLower()+"."+$longName.ToLower()+"@hypromat.com") -Department $SetUserDepartment -Manager $SetUserManager -Title $SetUserTitle

    # On ajoute l'utilisateur dans les groupes 
    foreach ($group in $Groups){
        Add-ADGroupMember -Identity $group -Members $NewUser
    }

}
