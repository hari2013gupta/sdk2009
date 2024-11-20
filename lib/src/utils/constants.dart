const testPdfUrl1mb =
    "https://file-examples.com/wp-content/storage/2017/10/file-example_PDF_1MB.pdf";
const testPdfUrl150 =
    'https://file-examples.com/wp-content/storage/2017/10/file-sample_150kB.pdf';
const imgUrl500 =
    'https://file-examples.com/wp-content/storage/2017/10/file_example_JPG_500kB.jpg';
const imgUrl100 =
    'https://file-examples.com/wp-content/storage/2017/10/file_example_JPG_100kB.jpg';
const otherUrl = 'http://ovh.net/files/1Mio.dat';
const pdfUrlDummy =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
const String fileUrlmp4 =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
const String webviewContent = '''
     <!DOCTYPE html>
     <html lang="en">
     <head>
     <title>Load file or HTML string example</title>
     </head>
     <body>

     <h1>Local demo page</h1>
     <p>
      This is an example page used to demonstrate how to load a local file 
      or 
      HTML 
      string using the <a 
      href="https://google.com">Google
      page</a> page.
     </p>

    </body>
    </html>
    ''';

extension E on String {
  String lastChars(int n) => substring(length - n);
}

extension Substrings on String {
  /// Takes the first n characters.
  String takeFirst(int n) {
    final int end = n > length ? length : n;
    return substring(0, end);
  }

  /// Takes the last n characters.
  String takeLast(int n) {
    final int start = n > length ? 0 : length - n;
    return substring(start, length);
  }

  /// Drops the first n characters.
  String dropFirst(int n) {
    return n > length ? "" : substring(length - n, length);
  }

  /// Drops the last n characters.
  String dropLast(int n) {
    return n > length ? "" : substring(0, length - n);
  }
}

class Const {
  static String newString(String oldString, int n) {
    String result = '';
    if (oldString.length >= n) {
      result = oldString.substring(oldString.length - n);
      return result;
    } else {
      return oldString;
      // return whatever you want
    }
  }
}
