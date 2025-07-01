class BanaValidator {

  // V A L I D A S I  E M A I L
  static String? validasiEmail(String? value, String? email) {
    if (value == null || value.isEmpty) {
      return 'Isikan email Anda';
    }
    final RegExp emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailReg.hasMatch(value)) {
      return 'Isikan email Anda dengan benar!';
    } return null;
  }

  // V A L I D A S I  U S E R N A M E
  static String? validasiUserame(String? value, String? username) {
    if (value == null || value.isEmpty) {
      return 'Isikan username Anda';
    }
    final RegExp usernameReg = RegExp(r'^.{4,16}$');
    if (!usernameReg.hasMatch(value)) {
      return 'Username harus terdiri dari 4 hingga 16 karakter';
    } return null;
  }

  // V A L I D A S I  P A S S W O R D
  static String? validasiPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Isikan Password Anda';
    }

    if (value.length < 7) {
      return 'Password minimal 8 huruf';
    }

    if(!value.contains(RegExp((r'[A-Z]')))) {
      return 'Password harus mengandung huruf kapital';
    }

    if(!value.contains(RegExp((r'[0-9]')))) {
      return 'Password harus mengandung angka';
    } return null;
  }

  // V A L I D A S I  N O M O R
  static String? validasiNomorTelefon(String? value, String? nomorTelepon) {
    String pattern = r'^\+?[0-9]{10,15}$';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Isikan Nomor Ponsel Anda';
    }

    if (value.length <9) {
      return 'Isikan nomor ponsel Anda dengan benar!';
    }

    if (value.isEmpty) {
      return 'Isikan nomor ponsel Anda';
    }

    else if (!regExp.hasMatch(value)) {
      return 'Isikan nomor ponsel Anda dengan benar!';
    }
    return null;
  }

  // V A L I D A S I  F O R M
  static String? validasiForm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Form tidak boleh kosong';
    }
    final RegExp usernameReg = RegExp(r'^.{4,200}$');
    if (!usernameReg.hasMatch(value)) {
      return 'Mohon isi form dengan benar';
    } return null;
  }

  // V A L I D A S I   I N P U T  D A T A
  static String? validasiInputKotak(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon isi angka';
    }
    final regex = RegExp(r'^(10|[1-9]?)$');
    if (!regex.hasMatch(value)) {
      return 'Maksimal Kotak yang Bisa Dibuat adalah 10';
    }
    return null;
  }

  // V A L I D A S I  P E R S E N T A S E
  static String? validasiInputPersentase(String? value) {
  if (value == null || value.isEmpty) {
    return 'Mohon isi angka';
  }

  final regex = RegExp(r'^(100|[1-9][0-9]?)$');
  if (!regex.hasMatch(value)) {
    return 'Maksimal angka adalah 100';
  }

  return null;
}
}