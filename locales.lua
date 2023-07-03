Global("locales", {})
--create tables of each language
locales["eng_eu"]={}
locales["rus"]={}
locales["fr"]={}
locales["ger"]={}
locales["tr"]={}
--Gift of Tensess
locales["eng_eu"][ "ressName" ] = "Gift of Tensess"
locales["fr"][ "ressName" ] = "Don de Tensess"
locales["rus"][ "ressName" ] = "Дар Тенсеса"
locales["ger"][ "ressName" ] = "Geschenk von Tensess"
locales["tr"][ "ressName" ] = "Tenses’in H/252neri"
--ChatLog output sum of resses
locales["eng_eu"][ "chatLogMid" ] = "has been ressed"
locales["fr"][ "chatLogMid" ] = "a ete ressuscite"
locales["rus"][ "chatLogMid" ] = "возрождался"
locales["ger"][ "chatLogMid" ] = "wurde"
locales["tr"][ "chatLogMid" ] = ""

locales["eng_eu"][ "chatLogEnd" ] = "times."
locales["fr"][ "chatLogEnd" ] = "fois."
locales["rus"][ "chatLogEnd" ] = "раз."
locales["ger"][ "chatLogEnd" ] = "wiederbelebt."
locales["tr"][ "chatLogEnd" ] = "kez dirildi."

locales["eng_eu"][ "noData" ] = "no data."
locales["fr"][ "noData" ] = "Pas de donn/233es."
locales["rus"][ "noData" ] = "Нет данных."
locales["ger"][ "noData" ] = "Keine Daten."
locales["tr"][ "noData" ] = "Veri yok."

locales = locales[common.GetLocalization()] -- trims all other languages except the one that common.getlocal got.