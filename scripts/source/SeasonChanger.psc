ScriptName SeasonChanger extends ObjectReference Hidden

float Function ChangeSeasonLodDirectory(int newSeason, string installLocation, string dataLocation) global native

Function changeSeason(int newSeason) global

	; 1 = Spring
	; 2 = Summer
	; 3 = Autumn
	; 4 = Winter
	
	if (newSeason == 0)
		debug.notification("Season is 0. This should not be possible!")
	endif 

	debug.notification("Season will become: " + newSeason)

	String ChangeListFile = "../SkyrimSeasons/ChangeLists/ChangeList.json"
	String[] List = new String[4]
	List[0] = "TextureSetList"
	List[1] = "WorldModelList"
	List[2] = "LodList"
	
	int i = 0
	while (i < 3)
		
		String[] Season = new String[4]
		Season[0] = "Spring\\"
		Season[1] = "Summer\\"
		Season[2] = "Autumn\\"
		Season[3] = "Winter\\"
		int StringListCount = JsonUtil.StringListCount(ChangeListFile, List[i])
		int iterator = 1
		while (iterator < StringListCount)
			
			String currentObjectString = JsonUtil.StringListGet(ChangeListFile, List[i], iterator)
			Form currentObject
			if (i == 0) ;TextureSetList
				
				; esm/esp path ; formID : Diffuse path | Normal/Gloss path
				
				String sourceFilePath = StringUtil.SubString(currentObjectString, 0, StringUtil.find(currentObjectString, ";"))
				int formID = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, StringUtil.find(currentObjectString, ":")) as int
				String diffusePath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ":") + 1, StringUtil.find(currentObjectString, "|"))
				String normalPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, "|") + 1, 0)

				currentObject = Game.GetFormFromFile(formID, sourceFilePath)
				if(currentObject)
					(currentObject as TextureSet).SetNthTexturePath(0, Season[newSeason - 1] + diffusePath)
					(currentObject as TextureSet).SetNthTexturePath(1, Season[newSeason - 1] + normalPath)
				Else
					debug.Notification("currentobject is null")
				Endif

			elseif (i == 1) ;WorldModelList
				
				; esm/esp path ; formID : model path
				String sourceFilePath = StringUtil.SubString(currentObjectString, 0 , StringUtil.find(currentObjectString, ";"))
				int formID = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, StringUtil.find(currentObjectString, ":")) as int
				String modelPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObject, ":") + 1, 0)

				currentObject = Game.GetFormFromFile(formID, sourceFilePath)
				currentObject.SetWorldModelPath(Season[newSeason - 1] + modelPath)
				
			else ;LodList
				
				; install path ; directory path
				String installPath = StringUtil.SubString(currentObjectString, 0, StringUtil.find(currentObjectString, ";"))
				String directoryPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, 0)
				float f = ChangeSeasonLodDirectory(newSeason, installPath, directoryPath)
				
			endif
			
			iterator += 1
			
		EndWhile
		
		i += 1
		
	EndWhile
	
	debug.Notification("Done changing.")

EndFunction 