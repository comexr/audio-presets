--INSTALLATIE--
1. Kopieer het hele mapje naar een plek op het bestandssysteem (bijv. Documenten)
2. Open de terminal in de map "audio_presets"
3. Geef het script rechten met: 	sudo chmod +x audio_preset.sh
4. Voer het script uit: 		./audio_preset
5. Kijk in de terminal voor bugs of foutmeldingen, als deze er zijn, graag even Laurens aanspreken :)

--NIEUWE PRESETS TOEVOEGEN--
Mocht je een preset hebben gemaakt die goed klinkt op de laptop kun je deze toevoegen aan het script op de volgende manier:
1. Sla de preset op (bijv. met de naam test)
2. Navigeer naar de folder: ~/.config/[PulseEffects of easyeffects]/output/
3. Kopieer het aangemaakte preset bestand (test.json) naar de folder "audio_presets/presets" op de NAS
4. Verander de naam naar de volgende opmaak: [MODEL_LAPTOP]_[SOORT PLUGIN].json
	-Model laptop kun je vinden door in een terminal het volgende uit te voeren: sudo dmidecode | grep "Name:" | head -n 1
	-Soort plugin is of "pulseeffects" of "easyeffects"
	-Dus bij model PD5x_7xPNP_PNR_PNN_PNT en pulseeffects is de bestandnaam als volgt: PD5x_7xPNP_PNR_PNN_PNT_pulse.json
	-Of bij bijv. model NS5x_NS7xPU en easyeffects is de bestandnaam als volgt: NS5x_NS7xPU_easy.json 
5. Nu zou bij de volgende laptop die geinstalleerd wordt, deze preset worden gepakt als standaard.	

--BUGS--
Er zit blijkbaar nog een bug in de huidige versie van pulseeffects
Na een reboot wordt de preset niet goed ingeladen, als je dan vervolgens een andere preset selecteert en dan weer terug gaat naar de vorige doet ie het wel.

!!!Tot nu toe alleen aanwezig in Ubuntu (22.04)!!!
OS's waar het niet aanwezig is:
-Fedora 36
-Zorin 16.1
-Manjaro 21
-Linux Mint

Beetje jammer, maar kunnen we niets aan doen.
Enige fix schijnt dus een downgrade van 4 pakketjes te zijn, maar doe ik niet graag i.v.m. security patches die je dan stilzet voor de rest van de levensduur van het huidig geinstalleerd OS.

Momenteel op zoek naar een workaround.
Info: https://bugs.launchpad.net/ubuntu/+source/d-conf/+bug/1948882
