Function Install-Scoop {

	New-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" ` 
					 -propertyType ExpandString `
					 -name "SCOOP_GLOBAL" `
					 -value "${ENV:PROGRAMDATA}\scoop"

	Invoke-WebRequest 'https://get.scoop.sh' | Invoke-Expression

	'scoop install Git-with-OpenSSH Sudo Which --global' | Set-Content -path temp_script.ps1
	Start-Process PowerShell -verb RunAs -argument "-noProfile $(Convert-Path .\temp_script.ps1)"
	Remove-Item temp_script.ps1 -force

	scoop bucket add Extras
	scoop bucket add Nirsoft

}

Function Install-Chocolatey-OldWay {

	Start-Process PowerShell -verb RunAs -argument "-noProfile Invoke-WebRequest 'https://chocolatey.org/install.ps1' | Invoke-Expression"
	refreshEnv
	pushd "${env:ChocolateyInstall}\tools"
	sudo .\shimgen --output="..\bin\shimgen.exe" --path="..\tools\shimgen.exe" | Out-Null
	popd
	
}

Function Install-Chocolatey {

	Install-PackageProvider Chocolatey -scope CurrentUser
	Set-PackageSource -name Chocolatey -trusted
	
}

Function Install-ChocolateyPackages-OldWay {

	# Basic utilities
	sudo choco install 7zip.install 7zip.commandline -y -pre

	# Libraries
	sudo choco install VCredist-All JRE8 -y

	# Registry, Environment, System Management utilities
	sudo choco install Rapidee RegistryManager DoubleCmd Rufus SysInternals SystemExplorer -y
	scoop install OpenedFilesView

	# Shells, Terminals and launchers
	sudo choco install CmderMini Keypirinha LinkShellExtension Putty Streams -y

	# Text editors, finders and organizers
	sudo choco install NotepadPlusPlus.install --x86 -y
	sudo shimgen --output="${env:ChocolateyPath}\bin\npp.exe" `
				 --path="${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" `
				 --iconPath="${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" `
				 --gui
	sudo choco install Everything Ditto.install -y

	# Internet
	sudo choco install QbitTorrent GoogleChrome -y

	# Media viewers / managers
	sudo choco install SumatraPDF.install Calibre  Vlc Foobar2000 Fsviewer Dropbox -y

	# Development IDEs
	sudo choco install Webstorm Phpstorm -y

	# Development tools
	sudo choco install Kdiff3 Winscp.portable Lepter jq -y

}

Function Install-ChocolateyPackages {
	PARAM(
		[Parameter( Mandatory )]
		[String[]] $packages
	)

	$packages | ForEach { Install-Package $_ -verbose }
}

Function Install-ScoopPackages {
	PARAM(
		[Parameter( Mandatory )]
		[String[]] $packages
	)
	
	$packages | ForEach { scoop install $_ }

}


$chocoPackages =  @(
	'7zip.install', '7zip.commandline',       	# Basic utilities
	'VCredist-All', 'JavaRuntime', 			# Libraries
	'Rapidee', 'RegistryManager', 'Rufus',		# Registry, Environment, System Management utilities
	'SysInternals', 'SystemExplorer',           	# 
	'CmderMini', 'DoubleCmd', 'Keypirinha', 	# Shells, Terminals and Launchers
	'LinkShellExtension', 'Putty', 'Streams',	#
	'Ditto.install', 'Everything', 			# Text editors, finders and organizers
	'NotepadPlusPlus.install',			#
	'QbitTorrent', 'GoogleChrome',              	# Internet
	'SumatraPDF.install', 'Calibre', 'Vlc',     	# Media viewers / Managers
	'Foobar2000', 'Fsviewer', 'Dropbox',        	#
	'Webstorm', 'Phpstorm',                     	# Development IDEs
	'Kdiff3', 'WinSCP.portable', 'Lepter', 'jq' 	# Development tools
)

$chocoPackagesLight =  @(
	'7zip.install', '7zip.commandline',       	# Basic utilities
	'Rapidee', 'RegistryManager', 'SystemExplorer', # Registry, Environment, System Management utilities
	'CmderMini', 'Keypirinha', 'DoubleCmd',		# Shells, Terminals and Launchers
	'LinkShellExtension', 'Putty',  		#
	'Everything', 'NotepadPlusPlus.install',	# Text editors, finders and organizers
	'QbitTorrent', 'GoogleChrome',              	# Internet
	'SumatraPDF.install', 'Vlc',     		# Media viewers / Managers
	'Foobar2000', 'Fsviewer'         		#
)

$chocoPackagesX86 = @(
	'NotepadPlusPlus.install'			# Text editors, finders and organizers
)

$scoopPackages = @(	
	'Filetypesman', 'ShellExView',              	# Registry, Environment, System Management utilities
	'ShellMenuView', 'RegDllView',              	#
	'OpenedFilesView'				# 
)



Install-Scoop
sudo Install-Chocolatey

sudo Install-ChocolateyPackages $chocoPackagesLight 
Install-ScoopPackages $scoopPackages 
