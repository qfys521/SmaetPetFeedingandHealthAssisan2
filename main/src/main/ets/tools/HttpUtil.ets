import http from "@ohos.net.http";
import { JSON } from "@kit.ArkTS";


interface Data {
  key: string;
  value: string;
}

export class HttpUtil{
  /**
   * 发出HttpGet请求
   *
   * @param url 请求链接
   * @param params 请求参数
   * @returns 实例对象 T
   * @throws 请求错误
   */
  public async httpRequestGet<T>(url:string , params?: Data[]): Promise<T> {
    let request =  http.createHttp()
    if (params?.length) {
      const query = params.map(p =>
      `${encodeURIComponent(p.key)}=${encodeURIComponent(p.value)}`
      ).join('&');
      url += `?${query}`;
    }
    let response = await request.request(
      url,
      {
        method:http.RequestMethod.GET,
        header:{
          'Content-Type': 'application/json'
        }
      }
    )
    return JSON.parse(response.result.toString()) as T;
  }
  /**
   * 发出HttpPost请求
   *
   * @param url 请求链接
   * @param params 请求参数
   * @param extraDates post的数据
   * @returns 实例对象 T
   * @throws 请求错误
   */
  public async httpRequestPost<T>(url:string , extraDates?:string, params?: Data[]): Promise<T> {
    let request =  http.createHttp()
    if (params?.length) {
      const query = params.map(p =>
      `${encodeURIComponent(p.key)}=${encodeURIComponent(p.value)}`
      ).join('&');
      url += `?${query}`;
    }

    console.info(url)
    let response = await request.request(
      url,
      {
        method:http.RequestMethod.POST,
        // header:{
        //   // 'Content-Type': '*/*'
        // },
        // extraData: extraDates
      }
    )
    return JSON.parse(response.result.toString()) as T
  }
}