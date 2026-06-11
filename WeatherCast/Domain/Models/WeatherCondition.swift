import Foundation

enum WeatherCondition {
    case sunny
    case partlyCloudy
    case overcast
    case fog
    case drizzle
    case rainy
    case snowy
    case sleet
    case thunder
    case blizzard

    init(code: Int) {
        switch code {
        case 1000:
            self = .sunny
        case 1003, 1006:
            self = .partlyCloudy
        case 1009:
            self = .overcast
        case 1030, 1135, 1147:
            self = .fog
        case 1063, 1150, 1153, 1168, 1171:
            self = .drizzle
        case 1180, 1183, 1186, 1189, 1192, 1195, 1198, 1201, 1240, 1243, 1246:
            self = .rainy
        case 1117, 1225:
            self = .blizzard
        case 1066, 1114, 1210, 1213, 1216, 1219, 1222, 1255, 1258:
            self = .snowy
        case 1069, 1072, 1204, 1207, 1249, 1252:
            self = .sleet
        case 1087, 1273, 1276, 1279, 1282:
            self = .thunder
        default:
            self = .sunny
        }
    }
}
