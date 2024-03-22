import 'package:gsheets/gsheets.dart';

class GsheetApi {
  static const _credentials = r''' {
  "type": "service_account",
  "project_id": "moneytrack-413218",
  "private_key_id": "2e64d0b9358d748f90dcec81b6eb950cc04deee8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCoPxOkhaEDSwCc\nD0BaCrswvDr3sDkApNvfcDka1cB/N/yb2O0t/9JXiNqf98t6Qdy+76PvFaoBKWhc\nuoDvmYjQ1AEdFLG6XtU3kthECX5iaRtpnQJbYL5tChpEXch/ktACy+Rq+78lNVLY\nTtzl12S9LYRZePqwOQaL9oHaHEFcCNR7X0P8tv7eue5Lkz+c6auoOU5RIcLKCUAT\nY8zktncdhf9m3+lIV0XMVbbMMZn6uywujbyIRjqiPWS4efP3Bj5pXyP5QsfYGvlA\nWK4lLM6ICfzAvld9xCi+rXuGhu07uQwI8Ae6Z72WjrzNspexWESWfJA1SDRe1KF5\nrBCh9v6lAgMBAAECggEACoWjW1joYZppbGttMDj7uv7AWQ1dr9WNUvfs1KCXd7Qz\nu8oBM+PnZarGMg1fJt66CPxXl11Nab1UbMHnOflqFx8HtV7QTvR4osZUeN6Jsv0r\n88iYDlsTnbRIr0KYz4SKEez84kViIbODhu6ii5UBAlwTBmJRLP/HbWS1xGfAHT9b\nhGmR+z7tVOS9hpe3rWqQxpTSAY+UpJdoB3DkiaLGXFo05dtmsjx33UQpIDWY3d9f\nr+RIMkTMvoU4D9py66WYJ583ZgKd215h7CSb9QclISisiU+qTbckB+ua56L41F8O\nUQ2GOEyiarRZLMQ4TtvtZdTLcEDAcxGSrPa6EVDfAwKBgQDgFT99wsYRExTPMCrZ\nmaAMlvujVOZftpX8KgOgCBIuj1dDsAUBbCvr2TxPDvXWeiuErWyROG9PBcbDn5Wv\nnkoY026/DdXx2EDAO6H0xWp4ncJ8JOnZQar2TKAnH2LPx6a0jtXliCmD6Z1WzA2I\nHUR7ZAWYXXKhauLXqnSFZ/cR1wKBgQDANdrrTHmd+o6B2TLfGtwgXhrdDLhrKaWq\nzRvPWnzIRwzVT1KmqCuYTQxvCYlOnqNpAFk4pNM63tH4sUQRSMev/wthR0H/M5FH\nRDzeL3wabPUPrG+qxF3dcosSbivIKBi5IV/oBYfw5dPCi/NTvmkHAdUQjms6bExo\nE1gjDfOb4wKBgQCrMRB0b50J5l37e30BCNCxTZepTG9DqCYlo6NpW0EouPGeEJeC\nYrWbVTcx3ugJlwQwNJ3AxDClWnBje0PMC03ocX8mDtfoD6JIOkaczUVuKHgwh7Lv\n+680w42G1f+TZaACSS04UjIFSTCe4v1jg5iR+/QaVyoAD7yFrv+d+7NRuQKBgQCn\nJW4lllBgOAX7FwTtDO+F2i/kMG6jCgl9+XWIoLjIdTjMunk2YiHfBImeeZ2E1+Fk\nqx/raTIjDKdta8G0giTcgJ7FznCu24onfkisMoDqffux0JMe3jp+G2Ci+1lpaqzt\nOP+sxjqMG2BF2uwT1A6DQG2nQyIuIQVksAXCHhzNXwKBgB1DQxeg2PUI25m8zC4Q\nTBFKG1wxxMOZt00FVBGP7nakxNPAt9yXczW5MEZ+j8lxENAKRRsWYNbsNLc6qztR\nyxPPrJwSPiquw1N5Xvi7yANP2lXIkCHSyME0AWowR9MxgytOFc965HHZ6N5PR8Hs\nsl7/njIEYqFHvq84J3yP+6GU\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-manager@moneytrack-413218.iam.gserviceaccount.com",
  "client_id": "115553457253876084755",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-manager%40moneytrack-413218.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

  static const _spreadSheetID = '18rAyp6NpCX_46cpq4nb9LilKugVqFNjLtZJArmOkHrM';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  //variables to track
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = false;

  //init spreadsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadSheetID);
    _worksheet = ss.worksheetByTitle('Expense Sheet');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (var i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .add([transactionName, transactionAmount, transactionType]);
      }
    }
    loading = false;
  }

  static Future insert(String name, String amount, bool isIncome) async {
    if (_worksheet == null) {
      return;
    }
    numberOfTransactions++;
    currentTransactions
        .add([name, amount, isIncome == true ? 'Income' : 'Expense']);
    await _worksheet!.values
        .appendRow([name, amount, isIncome == true ? 'Income' : 'Expense']);
  }

  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'Income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'Expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
