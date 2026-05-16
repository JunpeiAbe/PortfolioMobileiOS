import Foundation
/// 入力時に許可する文字種
enum AllowedCharacterRegex: String {
    /// 半角英数字
    case halfWidthAlphanumeric = "[0-9a-zA-Z]"
    /// 半角数字
    case halfWidthNumbers = "[0-9]"
    /// 半角英字
    case halfWidthAlphabet = "[a-zA-Z]"
    /// 半角英数記号
    case halfWidthSymbols = "[ -~]"
    /// 半角メールアドレス使用記号
    case emailSymbols = "[0-9a-zA-Z#\\$&'*+./=?@^_{}~-]"
    /// 半角英数パスワード使用記号
    case passwordSymbols = "[0-9a-zA-Z!\"#\\$%&'@_-]"
    /// 全角文字
    case fullWidthCharacters = "[^ -~｡-ﾟ\t]"
    /// 全角カナ
    case fullWidthKatakana = "[ァ-タダ-ヶー]"
    /// 全角文字、半角英数記号（混在）
    case mixedFullAndHalfWidth = "[^\t]"
    /// パスワードポリシー
    //　半角英数字8桁以上32桁以下 ^.{8,32}$
    //  記号を含む (?=.*?[!\"#$%&'@_-])
    //  英文字(大文字・小文字)、数字、記号をそれぞれ一つ以上含む (?=.*?[0-9])(?=.*?[a-zA-Z])
    case passwordPolicy = "^(?=.*?[0-9])(?=.*?[a-zA-Z])(?=.*?[!\"#$%&'@_-])[0-9a-zA-Z!\"#$%&'@_-]{8,32}$"

    /// 正規表現を取得
    var pattern: String {
        return self.rawValue
    }
}

