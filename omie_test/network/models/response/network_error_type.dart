const DEFAULT_ERROR_MESSAGE = 'Não foi possível prosseguir. Tente novamente mais tarde';

enum NetworkErrorType {
  DEFAULT,
  COMPANY_IS_NOT_TRADEMASTER_CLIENT,
  COMPANY_IS_REGISTERED,
  COMPANY_REGISTRATION_REFUSED,
  CPF_NOT_FOUND_PARTNERS_LIST,
  CPF_INVALID_DATA,
  SMS_INVALID_CODE,
  EMAIL_INVALID_CODE,
  CUSTOMER_REGISTER_NOT_FOUND,
  REGISTRATION_BLOCKED,
  DOCUMENT_PHOTOS_WITH_INSUFFICIENT_QUALITY,
  PROFILE_PHOTOS_WITH_INSUFFICIENT_QUALITY,
  INVALID_PERSONAL_DATA,
  EMAIL_ALREADY_IN_USE,
  CNPJ_BLOCKED,
}

extension ErrorTypeExtension on NetworkErrorType {
  String get message {
    switch (this) {
      case NetworkErrorType.DEFAULT:
        return DEFAULT_ERROR_MESSAGE;
      case NetworkErrorType.COMPANY_IS_NOT_TRADEMASTER_CLIENT:
        return '';
      case NetworkErrorType.COMPANY_IS_REGISTERED:
        return '';
      case NetworkErrorType.COMPANY_REGISTRATION_REFUSED:
        return 'Cadastro de empresa recusado';
      case NetworkErrorType.CPF_NOT_FOUND_PARTNERS_LIST:
        return 'É necessário que você seja um dos membros que consta na consulta do quadro de sócios e administradores da sua empresa';
      case NetworkErrorType.CPF_INVALID_DATA:
        return 'Os dados informados foram reprovados';
      case NetworkErrorType.SMS_INVALID_CODE:
        return 'Código incorreto';
      case NetworkErrorType.EMAIL_INVALID_CODE:
        return 'Código incorreto';
      case NetworkErrorType.CUSTOMER_REGISTER_NOT_FOUND:
        return 'Cadastro não encontrado no sistema';
      case NetworkErrorType.REGISTRATION_BLOCKED:
        return 'Validação de foto recusada';
      case NetworkErrorType.DOCUMENT_PHOTOS_WITH_INSUFFICIENT_QUALITY:
        return 'A qualidade da foto coletada não passou em nossas validações';
      case NetworkErrorType.PROFILE_PHOTOS_WITH_INSUFFICIENT_QUALITY:
        return 'A qualidade da foto coletada não passou em nossas validações';
      case NetworkErrorType.INVALID_PERSONAL_DATA:
        return 'Verifique os dados informados para cadastro';
      case NetworkErrorType.EMAIL_ALREADY_IN_USE:
        return 'E-mail já cadastrado.';
      case NetworkErrorType.CNPJ_BLOCKED:
        return 'Entre em contato com o nosso suporte.';
      default:
        return DEFAULT_ERROR_MESSAGE;
    }
  }
}

NetworkErrorType getNetworkErrorTypeByCode(String code) {
  switch (code) {
    case '001':
      return NetworkErrorType.DEFAULT;
    case '010':
      return NetworkErrorType.COMPANY_IS_NOT_TRADEMASTER_CLIENT;
    case '011':
      return NetworkErrorType.COMPANY_IS_REGISTERED;
    case '012':
      return NetworkErrorType.COMPANY_REGISTRATION_REFUSED;
    case '013':
      return NetworkErrorType.CPF_NOT_FOUND_PARTNERS_LIST;
    case '014':
      return NetworkErrorType.CPF_INVALID_DATA;
    case '027':
      return NetworkErrorType.SMS_INVALID_CODE;
    case '025':
      return NetworkErrorType.EMAIL_INVALID_CODE;
    case '020':
      return NetworkErrorType.CUSTOMER_REGISTER_NOT_FOUND;
    case '030':
      return NetworkErrorType.REGISTRATION_BLOCKED;
    case '028':
      return NetworkErrorType.DOCUMENT_PHOTOS_WITH_INSUFFICIENT_QUALITY;
    case '029':
      return NetworkErrorType.PROFILE_PHOTOS_WITH_INSUFFICIENT_QUALITY;
    case '031':
      return NetworkErrorType.INVALID_PERSONAL_DATA;
    case '032':
      return NetworkErrorType.EMAIL_ALREADY_IN_USE;
    case '034':
      return NetworkErrorType.CNPJ_BLOCKED;
    default:
      return NetworkErrorType.DEFAULT;
  }
}
