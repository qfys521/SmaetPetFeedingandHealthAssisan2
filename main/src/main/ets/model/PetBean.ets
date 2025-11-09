export class PetBean {
  constructor(id?: number, userId?: number, petName?: string, petSpecies?: string, petBreed?: string, petGender?: string,
    birthDate?: string, currentWeight?: number, healthStatus?: string, createdAt?: string, updatedAt?: string) {
    this.id = id
    this.userId = userId
    this.petName = petName
    this.petSpecies = petSpecies
    this.petBreed = petBreed
    this.petGender = petGender
    this.birthDate = birthDate
    this.currentWeight = currentWeight
    this.healthStatus = healthStatus
    this.createdAt = createdAt
    this.updatedAt = updatedAt
  }
  // 宠物唯一标识
  id?: number
  // 关联用户ID
  userId?: number
  // 宠物名称
  petName?: string
  // 宠物种类（如：狗/猫）
  petSpecies?: string
  // 具体品种（如：金毛寻回犬）
  petBreed?: string
  // 性别（male/female）
  petGender?: string
  // 出生日期（ISO 8601格式）
  birthDate?: string
  // 当前体重（单位：kg）
  currentWeight?: number
  // 健康状态描述
  healthStatus?: string
  // 创建时间（带时区的时间戳）
  createdAt?: string
  // 最后更新时间（带时区的时间戳）
  updatedAt?: string 
}