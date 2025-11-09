/**
 * 宠物健康记录类 (Pet Health History)
 * 用于存储和管理单次体检或健康记录的详细信息
 */
export class PetHealthHistory {
  /** 宠物名字（Pet Name） */
  petName?: string
  /** 宠物品种（Pet Breed） */
  petBreed?: string
  /** 本次体检或记录的唯一编号（Record ID） */
  recordId?: string
  /** 宠物在系统中的唯一标识（Pet ID） */
  petId?: string
  /** 记录日期（Record Date），格式：YYYY-MM-DD */
  recordDate?: string
  /** 体重（Body Weight，单位：kg） */
  bodyWeight?: string
  /** 体温（Body Temperature，单位：℃） */
  bodyTemperature?: string
  /** 心率（Heart Rate，单位：次/分钟） */
  heartRate?: string
  /** 呼吸频率（Respiratory Rate，单位：次/分钟） */
  respiratoryRate?: string
  /** 食欲水平（Appetite Level: Excellent / Normal / Poor） */
  appetiteLevel?: string
  /** 精力水平（Energy Level: High / Normal / Low） */
  energyLevel?: string
  /** 疫苗接种状态（Vaccination Status: Up-to-date / Overdue） */
  vaccinationStatus?: string
  /** 上次接种疫苗的日期（Last Vaccination Date） */
  lastVaccinationDate?: string
  /** 驱虫状态（Deworming Status: Completed / Pending） */
  dewormingStatus?: string
  /** 上次驱虫日期（Last Deworming Date） */
  lastDewormingDate?: string
  /** 药物使用或过敏信息（Medication List / Allergy Notes） */
  medicationList?: string
  /** 观察到的症状（Observed Symptoms） */
  observedSymptoms?: string
  /** 兽医备注或建议（Vet Notes） */
  vetNotes?: string
  /** 下次检查日期（Next Checkup Date） */
  nextCheckupDate?: string
  /** 记录创建时间（UTC 格式，Created At） */
  createdAt?: string
  /** 记录创建时间（本地时间格式，Create Time） */
  creatTime?: string

  /**
   * 宠物健康记录构造函数
   * @param petName 宠物名字
   * @param petBreed 宠物品种
   * @param recordId 本次记录的唯一编号
   * @param petId 宠物在系统中的唯一ID
   * @param recordDate 记录日期（如体检日期）
   * @param bodyWeight 体重（kg）
   * @param bodyTemperature 体温（℃）
   * @param heartRate 心率（次/分钟）
   * @param respiratoryRate 呼吸频率（次/分钟）
   * @param appetiteLevel 食欲水平（如 Excellent, Normal, Poor）
   * @param energyLevel 精力水平（如 High, Normal, Low）
   * @param vaccinationStatus 疫苗接种状态（如 Up-to-date, Overdue）
   * @param lastVaccinationDate 上次接种疫苗的日期
   * @param dewormingStatus 驱虫状态（如 Completed, Pending）
   * @param lastDewormingDate 上次驱虫日期
   * @param medicationList 药物使用或过敏信息
   * @param observedSymptoms 观察到的症状或体征
   * @param vetNotes 兽医备注或建议
   * @param nextCheckupDate 下次检查日期
   * @param createdAt 记录创建时间（UTC 格式）
   * @param creatTime 记录创建时间（本地时间格式）
   */
  constructor(
    petName?: string,
    petBreed?: string,
    recordId?: string,
    petId?: string,
    recordDate?: string,
    bodyWeight?: string,
    bodyTemperature?: string,
    heartRate?: string,
    respiratoryRate?: string,
    appetiteLevel?: string,
    energyLevel?: string,
    vaccinationStatus?: string,
    lastVaccinationDate?: string,
    dewormingStatus?: string,
    lastDewormingDate?: string,
    medicationList?: string,
    observedSymptoms?: string,
    vetNotes?: string,
    nextCheckupDate?: string,
    createdAt?: string,
    creatTime?: string
  ) {
    this.petName = petName
    this.petBreed = petBreed
    this.recordId = recordId
    this.petId = petId
    this.recordDate = recordDate
    this.bodyWeight = bodyWeight
    this.bodyTemperature = bodyTemperature
    this.heartRate = heartRate
    this.respiratoryRate = respiratoryRate
    this.appetiteLevel = appetiteLevel
    this.energyLevel = energyLevel
    this.vaccinationStatus = vaccinationStatus
    this.lastVaccinationDate = lastVaccinationDate
    this.dewormingStatus = dewormingStatus
    this.lastDewormingDate = lastDewormingDate
    this.medicationList = medicationList
    this.observedSymptoms = observedSymptoms
    this.vetNotes = vetNotes
    this.nextCheckupDate = nextCheckupDate
    this.createdAt = createdAt
    this.creatTime = creatTime
  }
}
