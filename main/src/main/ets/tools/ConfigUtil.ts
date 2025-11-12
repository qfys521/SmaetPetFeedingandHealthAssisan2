import fs from '@ohos.file.fs'

/**
 * ConfigUtil
 * 基于 JSON 文件的配置管理工具类
 * 自动创建、加载、保存 JSON 文件
 */
export class ConfigUtil {
  private filePath: string
  private configData: Record<string, any> = {}
  private initialized: boolean = false

  /**
   * @param context UI 上下文（通常 this.getUIContext().getHostContext()）
   * @param fileName 配置文件名，不含路径（默认 "AppConfig.json"）
   */
  constructor(context: any, fileName: string = 'AppConfig.json') {
    const dir = context.filesDir!
    this.filePath = `${dir}/${fileName}`
  }

  /**
   * 初始化（如果文件不存在则创建）
   */
  private async init(): Promise<void> {
    if (this.initialized) return
    try {
      if (fs.accessSync(this.filePath)) {
        // ✅ 直接传入路径字符串，不要 openSync
        const content = fs.readTextSync(this.filePath, { encoding: 'utf-8' })
        this.configData = content ? JSON.parse(content) : {}
      } else {
        this.configData = {}
        this.saveToFile()
      }
      this.initialized = true
    } catch (err) {
      console.error(`ConfigUtil.init() error: ${JSON.stringify(err)}`)
      this.configData = {}
    }
  }


  /**
   * 写入文件（保存当前 configData）
   */
  private async saveToFile(): Promise<void> {
    try {
      const file = fs.openSync(this.filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY).fd
      fs.writeSync(file, JSON.stringify(this.configData, null, 2))
      fs.closeSync(file)
    } catch (err) {
      console.error(`ConfigUtil.saveToFile() error: ${JSON.stringify(err)}`)
    }
  }

  /**
   * 设置配置项
   */
  async set<T>(key: string, value: T): Promise<void> {
    await this.init()
    this.configData[key] = value
    await this.saveToFile()
  }

  /**
   * 获取配置项
   */
  async get<T>(key: string, defaultValue: T): Promise<T> {
    await this.init()
    return this.configData[key] ?? defaultValue
  }

  /**
   * 删除配置项
   */
  async remove(key: string): Promise<void> {
    await this.init()
    delete this.configData[key]
    await this.saveToFile()
  }

  /**
   * 判断配置项是否存在
   */
  async has(key: string): Promise<boolean> {
    await this.init()
    return key in this.configData
  }

  /**
   * 清空配置
   */
  async clear(): Promise<void> {
    await this.init()
    this.configData = {}
    await this.saveToFile()
  }

  /**
   * 获取所有配置
   */
  async getAll(): Promise<Record<string, any>> {
    await this.init()
    return this.configData
  }
}
