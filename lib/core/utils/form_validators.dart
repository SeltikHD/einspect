abstract final class FormValidators {
  static String? requiredField(
    String? value, {
    String message = 'Campo obrigatório',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    final requiredCheck = requiredField(value, message: 'Informe o e-mail');
    if (requiredCheck != null) return requiredCheck;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Informe um e-mail válido';
    }
    return null;
  }
}
