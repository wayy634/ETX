*EPass项目API接口设计*


名称： 用户注册 （POST）
URL： userRegister?mobile=(int)&password=(var)&code=(int)&deviceid=(var)&devicetoken=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userRegister?token=&mobile=17710171716&checkcode=0220&password=888888&deviceid=)
参数：
mobile:(int)
password:(var)
code:(int)
deviceid:(var)
devicetoken:(var)
返回参数：
code;

名称：用户登陆 （POST）
URL： userLogin?mobile=(int)&password=(var)&deviceid=(var)&devicetoken=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userLogin?token=&mobile=17710171716&password=123456&devideid=&devicetoken=)
参数：
mobile:(int)
password:(var)
deviceid:(var)
devicetoken:(var)
返回参数：
code; token; nickname; avatar; 

名称：用户注销 （POST）
URL： userLogout?token=(var)&deviceid=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userLogout?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&deviceid=)
参数：
token:(var)
deviceid:(var)
返回参数：
code;

名称：修改密码 （POST）
URL：userModifyPwd?token=(var)&deviceid=(var)&oldpwd=(var)&newpwd=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userModifyPwd?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&oldpwd=123456&newpwd=111111&deviceid=)
参数：
token:(var)
deviceid:(var)
oldpwd:(var)
newpwd:(var)
返回参数：
code;

名称：忘记密码 （POST）
URL：userForgetPwd?token=(var/null)&deviceid=(var)&mobile=(int)&code(int)&newpwd=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userUpdateProfile?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&nickname=hz&realname=%E4%BA%8C%E9%A5%BC&deviceid=)
参数：
token:(var/null)
deviceid:(var)
mobile:(int)
code:(int)
newpwd:(var)
返回参数：
code;

名称：更新资料 （POST）
URL：userUpdateProfile?token=(var)&deviceid=(var)&nickname=(var)&realname=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userModifyPwd?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&oldpwd=123456&newpwd=111111&deviceid=)
参数：
token:(var)
deviceid:(var)
nickname:(var/null)
realname:(var/null)
返回参数：
code;

名称：新增车辆信息 （POST）
URL：userAddCar?token=(var)&deviceid=(var)&licenceid=(var)&licencename=(var)&engineid=(var)&lpn=(var)&brand=(var)&boughttime=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userAddCar?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&licenceid=043585460546&licencename=%E4%BA%8C%E9%A5%BC&engineid=34546546&lpn=3434&brand=%E4%B8%B9%E7%94%AB%E8%82%A1%E4%BB%BD&boughttime=2015年9月12&deviceid=)
参数：
token:(var)
deviceid:(var)
licensceid:(var)
licencename:(var)
engineid:(var)
lpn:(var)
boughttime:(var)
返回参数：
code;

名称：更新车辆信息 （POST）
URL：userUpdateCar?token=(var)&deviceid=(var)&licenceid=(var)&licencename=(var)&engineid=(var)&lpn=(var)&brand=(var)&boughttime=(var)&carid=(int)
[DEMO URL](http://123.56.91.111:8080/epass/userUpdateCar?token=id-1id-1id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&carid=1&licenceid=043585460546&licencename=%E4%BA%8C%E9%A5%BC&engineid=34546546&lpn=3434&brand=%E4%B8%B9%E7%94%AB%E8%82%A11%E4%BB%BD&boughttime=2015/9.12&deviceid=)
参数：
token:(var)
deviceid:(var)
licensceid:(var)
licencename:(var)
engineid:(var)
lpn:(var)
boughttime:(var)
carid:(int)
返回参数：
code;


名称：新增车库信息 （POST）
URL： userAddGarage?token=(var)&deviceid=(var)&estate=(var)&location=(var)&type=(int:0/1)&area=(int:0/1)&isrent=(int:0/1)&rentfee=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userAddGarage?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&estate=0435854&location=%E6%B5%B7%E6%B7%80&deviceid=&type=1&area=1&isrent=1&rentfee=98$)
参数：
token:(var)
deviceid:(var)
estate:(var)
location:(var)
type:(int:0/1)
area:(int:0/1)
isrent:(int:0/1)
rentfee:(var)
返回参数：
code;


名称：更新车库信息 （POST）
URL： userUpdateGarage?token=(var)&deviceid=(var)&estate=(var)&location=(var)&type=(int:0/1)&area=(int:0/1)&isrent=(int:0/1)&rentfee=(var)&garageid=(int)
[DEMO URL](http://123.56.91.111:8080/epass/userUpdateGarage?token=id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&estate=0435854&location=%E6%B5%B7%E6%B7%80&deviceid=&type=1&area=1&isrent=1&rentfee=98RMB&garageid=1)
参数：
token:(var)
deviceid:(var)
estate:(var)
location:(var)
type:(int:0/1)
area:(int:0/1)
isrent:(int:0/1)
rentfee:(var)
garageid:(int)
返回参数：
code;

名称：新增设备绑定 （POST）
URL： userAddDevice?token=(var)&deviceid=(var)&etcdevice=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userAddDevice?token=id-1id-1id-1@n-150910092610@u-49e0469d3cdf40899a4051bfda905dd0&etcdevice=0435854&deviceid=)
参数：
token:(var)
deviceid:(var)
etcdevice:(var)
返回参数：
code;

名称：解绑设备（POST）
URL： userUnbindDevice?token=(var)&deviceid=(var)&etcdevice=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userUnbindDevice?token=id-1@n-150911092732@u-c2c3530b1b944a9d93a971f4452073a9&etcdevice=0435854)
参数：
token:(var)
deviceid:(var)
etcdevice:(var)
返回参数：
code;

名称：新增充值记录（POST）
URL： userCharge?token=(var)&deviceid=(var)&type=(int:0/1/2)&billsno=(var)&money=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userCharge?token=id-1@n-150911092732@u-c2c3530b1b944a9d93a971f4452073a9&type=1&billsno=992334934&money=100)
参数：
token:(var)
deviceid:(var)
type:(int:0/1/2)支付宝，第三方
billsno:(var)
money:(var)
返回参数：
code;


名称：新增帐户绑定（POST）
URL： userBindAccount?token=(var)&deviceid=(var)&type=(int:0/1/2)&accountname=(var)&accountholder=(var)
用途: *微信端使用*
参数：
token:(var)
deviceid:(var)
type:(int:0/1/2)支付宝，第三方
accountname(var)
accountholder(var)
返回参数：
code;

名称：获取用户资料（GET）
URL：userProfile?token=(var)&deviceid=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userProfile?token=id-1@n-150911092732@u-c2c3530b1b944a9d93a971f4452073a9)
参数：
token:(var)
deviceid:(var)
返回参数：
code; mobile; nickname; avatar; isbind; etcdevice; balance（当前余额）

名称：获取用户车辆资料（GET）
URL：userCar?token=(var)&deviceid=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userCar?token=id-1@n-150911092732@u-c2c3530b1b944a9d93a971f4452073a9)
参数：
token:(var)
deviceid:(var)
返回参数：
code; date(array){licenceid; licencename; engineid; lan; brand; boughttime;}

名称：获取用户车库资料（GET）
URL：userGarage?token=(var)&deviceid=(var)
[DEMO URL](http://123.56.91.111:8080/epass/userGarage?token=id-1@n-150911092732@u-c2c3530b1b944a9d93a971f4452073a9)
参数：
token:(var)
deviceid:(var)
返回参数：
code; date(array){estate; location; type; area; isrent; rentfee; }

名称：获取当前消费（GET）
URL：userToday?token=(var)&deviceid=(var)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
返回参数：
code; currentcost; recordcount; record（array）; {type; tollid; parkingid; duration; starttime; endtime; feeavg; fee;}

名称：获取当前消费（GET）
URL：userToday?token=(var)&deviceid=(var)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
返回参数：
code; currentcost; recordcount; record（array）; {parkingid; billno; duration; starttime; endtime; feeavg; fee; discounttype; discountinfo;}

名称：获取某日消费（GET）
URL：userDayCost?token=(var)&deviceid=(var)&day=(int:8:20150831)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
day:(int:8)
返回参数：
code; recordcount; totalcost; record（array）; {parkingid; billno; duration; starttime; endtime; feeavg; fee; discounttype; discountinfo;}

名称：获取账单列表消费（GET）
URL：userMonthCost?token=(var)&deviceid=(var)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
返回参数：
code; recordcount; totalcost; record（array）; {month; monthcost;}

名称：获取账单月消费（GET）
URL：userMonthCostDetail?token=(var)&deviceid=(var)&month=(int:6:201508)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
month:(int:6:201508)
返回参数：
code; recordcount; totalcost; record（array）; {day; daycost;}

名称：获取停车场信息（GET）
URL：userTollStation?token=(var)&deviceid=(var)&parkingid=(int)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
parkingid:(int)
返回参数：
code; title; gps-x; gps-y; type; scale; fee; feedesc; discountype; discountinfo; iscoop;

名称：获取设备信息（GET）
URL：userDevice?token=(var)&deviceid=(var)&etcdevice=(int)
[DEMO URL](http://123.56.91.111:8080/epass/userDevice?token=id-1@n-150911092732@u-c2c3530b1b944a9d93a971f4452073a9)
参数：
token:(var)
deviceid:(var)
etcdevice:(int)
返回参数：
code; etcdevice; status; is bind; bindtime;

名称：获取通知信息（GET）
URL：userGetNotice?token=(var)&deviceid=(var)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
返回参数：
code; title; content;

名称：获取用户钱包（GET）
URL：userGetWallet?token=(var)&deviceid=(var)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
返回参数：
code; balance;

名称：获取充值记录（GET）
URL：userChargeRecord?token=(var)&deviceid=(var)
DEMO URL: *调整中*
参数：
token:(var)
deviceid:(var)
返回参数：
code; balance; record（array）; {recordid; typeid;billsno; money; time}

名称：获取短信验证码（GET）
URL：phoneCode?token=(var)&mobile=(var)
[DEMO URL](http://123.56.91.111:8080/epass/phoneCode?mobile=17710171716&token=)
参数：
token:(var)
mobile:(var)
返回参数：
code; verifyCode;


