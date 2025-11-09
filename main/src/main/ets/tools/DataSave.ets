import { preferences } from "@kit.ArkData";

import { Context } from '@kit.AbilityKit';

export class DataSave{
  dataPreferences: preferences.Preferences | null = null;
  constructor(context:Context , dataName:string) {
    let options:preferences.Options = {
      name: dataName
    }
    this.dataPreferences = preferences.getPreferencesSync(context , options)
  }

  public set<V extends preferences.ValueType>(key:string , value:V){
    this.dataPreferences?.putSync(key , value)
    this.dataPreferences?.flushSync()
  }

  public get<V extends preferences.ValueType>(key:string){
    return this.dataPreferences?.getSync(key , '') as V
  }

  public deleted(key:string): boolean{
    try{
      this.dataPreferences?.deleteSync(key)
      this.dataPreferences?.flushSync()
      return true
    }catch (error){
      console.error(error)
      return false
    }
  }

  public clearAll():boolean{
    try{
      this.dataPreferences?.clear()
      return true
    }catch (err){
      console.error(JSON.stringify(err))
      return false
    }
  }
}
