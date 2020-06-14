import 'dart:convert';
import 'package:dio/dio.dart';

//http工具单例
class HttpManager {
  static final HttpManager _sharedManager = HttpManager._internal();
  factory HttpManager() => _sharedManager;
  Dio dio;
  HttpManager._internal() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
          baseUrl: WXApi.baseApi,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          receiveDataWhenStatusError: false,
          connectTimeout: 2000,
          receiveTimeout: 3000);
      dio = Dio(options);
    }
  }

  //封装get方法，换库只需换里面的实现
  Future get<T>(String url,
      {Map<String, String> headers,
      Map<String, dynamic> queryParameters,
      Function(WechatResponse) success,
      Function(ErrorEntity) error}) async {

    final Options options = Options(headers: headers);

    request(WXMethod.GET, url, params: queryParameters, success: (response) {

      print('get打印：$response');
      if (response != null) {

        WechatResponse wechatResponse = WechatResponse().transformDioResponseToWechatResponse(response);

        success(wechatResponse);
      } else {
        error(ErrorEntity(code: -1, message: '未知错误'));
      }
    }, error: (e) {
      error(e);
    });
//    Response response =
//        await dio.get(url, options: options, queryParameters: queryParameters);
//
//    if (response != null) {
//      WechatResponse wechatResponse = WechatResponse();
//      wechatResponse.data = response.data;
//      wechatResponse.headers = response.headers;
//      wechatResponse.request = response.request;
//      wechatResponse.statusCode = response.statusCode;
//      wechatResponse.statusMessage = response.statusMessage;
//      wechatResponse.extra = response.extra;
//      wechatResponse.redirects = response.redirects;
//      wechatResponse.isRedirect = response.isRedirect;
//
//      success(wechatResponse);
//    } else {
//      error(ErrorEntity(code: -1, message: '未知错误'));
//    }
  }

  //通用请求函数,返回类型是字典
  Future request<T>(WXMethod method, String path,
      {Map<String, dynamic> params,
      Function(Response) success,
      Function(ErrorEntity) error}) async {

    try {
      Response response = await dio.request(path,
          queryParameters: params,
          options: Options(method: WXMethodValues[method]));
      print('request打印:$response');
      if (response != null) {
//        BaseEntity entity = BaseEntity<T>.fromJson(response);
        if (response.statusCode == 200) {
          success(response);
        } else {
          error(ErrorEntity(code: response.statusCode, message: response.statusMessage));
        }
      } else {
        error(ErrorEntity(code: -1, message: '未知错误'));
      }
    } on DioError catch (e) {

      error(createErrorEntity(e));
    }
  }

  //通用请求函数,返回类型是数组
  Future requestList<T>(WXMethod method, String path,
      {Map<String, dynamic> params,
      Function(List<T>) success,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path,
          queryParameters: params,
          options: Options(method: WXMethodValues[method]));
      if (response != null) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: '未知错误'));
      }
    } on DioError catch (e) {
      error(createErrorEntity(e));
    }
  }

  // 错误信息处理函数
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(code: -1, message: "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            String errMsg = error.response.statusMessage;

            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(code: errCode, message: "请求语法错误");
                }
                break;
              case 403:
                {
                  return ErrorEntity(code: errCode, message: "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "无法连接服务器");
                }
                break;
              case 405:
                {
                  return ErrorEntity(code: errCode, message: "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return ErrorEntity(code: errCode, message: "服务器内部错误");
                }
                break;
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "无效的请求");
                }
                break;
              case 503:
                {
                  return ErrorEntity(code: errCode, message: "服务器挂了");
                }
                break;
              case 505:
                {
                  return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  return ErrorEntity(code: errCode, message: errMsg);
//              return ErrorEntity(code: errCode, message: "未知错误");
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
}

//自定义response，方便后期更改处理
class WechatResponse<T> {
  T data;
  Headers headers;
  RequestOptions request;
  int statusCode;
  String statusMessage;
  Map<String, dynamic> extra;
  List<RedirectRecord> redirects;
  bool isRedirect;

  WechatResponse({
    this.data,
    this.headers,
    this.request,
    this.isRedirect,
    this.statusCode,
    this.statusMessage,
    this.redirects,
    this.extra,
  });

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }

  WechatResponse transformDioResponseToWechatResponse(Response response) {
    WechatResponse wechatResponse = WechatResponse();
    wechatResponse.data = response.data;
    wechatResponse.headers = response.headers;
    wechatResponse.request = response.request;
    wechatResponse.statusCode = response.statusCode;
    wechatResponse.statusMessage = response.statusMessage;
    wechatResponse.extra = response.extra;
    wechatResponse.redirects = response.redirects;
    wechatResponse.isRedirect = response.isRedirect;

    return wechatResponse;
  }
}

//登陆信息
class LoginEntity {
  String account;
  String password;

  LoginEntity({this.account, this.password});

  factory LoginEntity.fromJson(json) {
    return LoginEntity(
      account: json["account"],
      password: json["password"],
    );
  }
}

//请求方法枚举
enum WXMethod { GET, POST, DELETE, PUT }
//使用：NWMethodValues[NWMethod.POST]
const WXMethodValues = {
  WXMethod.GET: "get",
  WXMethod.POST: "post",
  WXMethod.DELETE: "delete",
  WXMethod.PUT: "put"
};

//接口
class WXApi {
  static final baseApi =
      "https://easy-mock.bookset.io/mock/5dfae67d4946c20a50841fa7/example/";
  static final loginPath =
      "user/login"; //接口返回：{"code": int, "message": "String", "data": {"account": "String", "password": "String"}}
  static final queryListPath =
      "/query/list"; //接口返回：{"code": ing, "message": "String", "data": [int, int, String, int, String, int]}
  static final queryListJsonPath =
      "/query/listjson"; //接口返回：{"code": int, "message": "String", "data": [{"account": "String", "password": "String"}， {"account": "String", "password": "String"}]}
}

//json转换辅助工厂，把json转为T（通用泛型）
class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return null;
    }
//可以在这里加入任何需要并且可以转换的类型，例如下面
//    else if (T.toString() == "LoginEntity") {
//      return LoginEntity.fromJson(json) as T;
//    }
    else {
      return json as T;
    }
  }
}

//数据基类，返回的参数为 {“code”: 0, “message”: “”, “data”: {}}
class BaseEntity<T> {
  int code;
  String message;
  T data;

  BaseEntity({this.code, this.message, this.data});

  factory BaseEntity.fromJson(json) {

    return BaseEntity(
      code: json["code"],
      message: json["msg"],
      // data值需要经过工厂转换为我们传进来的类型
      data: EntityFactory.generateOBJ<T>(json["data"]),
    );
  }
}

//数据基类2，返回的参数为 {“code”: 0, “message”: “”, “data”: []}
class BaseListEntity<T> {
  int code;
  String message;
  List<T> data;

  BaseListEntity({this.code, this.message, this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = new List<T>();
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }

    return BaseListEntity(
      code: json["code"],
      message: json["msg"],
      data: mData,
    );
  }
}

//请求报错基类，{“code”: 0, “message”: “”}
class ErrorEntity {
  int code;
  String message;
  ErrorEntity({this.code, this.message});
}
