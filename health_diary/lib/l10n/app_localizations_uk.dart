// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get foodRecord => 'Запис про їжу';

  @override
  String get whatDidYouEat => 'Що ви їли?';

  @override
  String get dateTime => 'Дата і час';

  @override
  String get selectDateTime => 'Оберіть дату та час';

  @override
  String get today => 'Сьогодні';

  @override
  String get dishName => 'Назва страви';

  @override
  String get calories => 'Калорії';

  @override
  String get proteins => 'Білки (г)';

  @override
  String get fats => 'Жири (г)';

  @override
  String get carbs => 'Вуглеводи (г)';

  @override
  String get notes => 'Додаткові нотатки';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get foodSaved => 'Запис харчування збережено';

  @override
  String get moodRecord => 'Запис про самопочуття';

  @override
  String get howDoYouFeel => 'Як ви себе почуваєте?';

  @override
  String get happy => 'Щасливий';

  @override
  String get neutral => 'Нейтральний';

  @override
  String get sad => 'Сумний';

  @override
  String get stressed => 'Стресовий';

  @override
  String get energy => 'Енергія';

  @override
  String energyLevel(Object level) {
    return 'Рівень енергії: $level/10';
  }

  @override
  String get physicalState => 'Фізичний стан';

  @override
  String get bad => 'Поганий';

  @override
  String get good => 'Добра';

  @override
  String get goodState => 'Добрий';

  @override
  String get excellent => 'Відмінний';

  @override
  String get moodSaved => 'Самопочуття збережено';

  @override
  String get sleepRecord => 'Запис про сон';

  @override
  String get howDidYouSleep => 'Як ви спали?';

  @override
  String get duration => 'Тривалість сну (години)';

  @override
  String get quality => 'Якість сну';

  @override
  String get poor => 'Погана';

  @override
  String get great => 'Відмінна';

  @override
  String get sleepSaved => 'Запис сну збережено';

  @override
  String get sleepExcellent => 'Відмінна';

  @override
  String get historyTitle => 'Історія';

  @override
  String get all => 'Усе';

  @override
  String get noRecords => 'Немає записів';

  @override
  String get loadingError => 'Помилка завантаження';

  @override
  String get resetPassword => 'Відновлення паролю';

  @override
  String get enterEmail => 'Введіть email, щоб отримати інструкції';

  @override
  String get sendInstructions => 'Надіслати інструкції';

  @override
  String get backToLogin => 'Повернутися до входу';

  @override
  String get requiredField => 'Обов\'язкове поле';

  @override
  String get passwordMin6 => 'Мінімум 6 символів';

  @override
  String get ageInvalid => 'Невірний вік';

  @override
  String get nameHint => 'Ваше ім\'я';

  @override
  String get dishHint => 'Наприклад: Салат Цезар';

  @override
  String get notesHint => 'Розкажіть більше...';

  @override
  String get moodNotesHint => 'Розкажіть більше про ваше самопочуття...';

  @override
  String get sleepNotesHint => 'Розкажіть більше про ваш сон...';

  @override
  String get sortByDate => 'Сортувати за датою';

  @override
  String get emailSent => 'Лист надіслано! Перевірте пошту або папку \"Спам\"';

  @override
  String get loginSuccess => 'Вхід успішний!';

  @override
  String get registerSuccess => 'Реєстрація успішна!';

  @override
  String get language => 'Мова';

  @override
  String get myData => 'Мої дані';

  @override
  String get logout => 'Вийти з акаунта';

  @override
  String get logoutSuccess => 'Ви вийшли з акаунта';

  @override
  String get english => 'English';

  @override
  String get ukrainian => 'Українська';

  @override
  String get yearsOld => 'років';

  @override
  String get femaleGender => 'Жіноча';

  @override
  String get testCrash => 'Тест Crash (Sentry)';

  @override
  String get notRealeasedNow => 'Не реалізовано поки';

  @override
  String get january => 'Січня';

  @override
  String get february => 'Лютого';

  @override
  String get march => 'Березня';

  @override
  String get april => 'Квітня';

  @override
  String get may => 'Травня';

  @override
  String get june => 'Червня';

  @override
  String get july => 'Липня';

  @override
  String get august => 'Серпня';

  @override
  String get september => 'Вересня';

  @override
  String get october => 'Жовтня';

  @override
  String get november => 'Листопада';

  @override
  String get december => 'Грудня';

  @override
  String get invalidDuration => 'Невірна тривалість';

  @override
  String get recordSaved => 'Запис успішно збережено';

  @override
  String get errorSaving => 'Помилка збереження запису';

  @override
  String get fillAllFields => 'Будь ласка, заповніть всі обов\'язкові поля';

  @override
  String get fieldRequired => 'Поле обов\'язкове';

  @override
  String get enterDishName => 'Введіть назву страви';

  @override
  String get enterCalories => 'Введіть кількість калорій';

  @override
  String get enterValidNumber => 'Введіть дійсний номер';

  @override
  String get enterNotes => 'Введіть нотатки (необов\'язково)';

  @override
  String get deleteRecord => 'Видалити запис';

  @override
  String get appTitle => 'Щоденник здоров\'я';

  @override
  String get login => 'Увійти';

  @override
  String get register => 'Зареєструватися';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get noAccount => 'Немає акаунта?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get emailInvalid => 'Невірний email';

  @override
  String get createAccount => 'Створити акаунт';

  @override
  String get joinHealthyLife => 'Приєднайтеся до здорового способу життя';

  @override
  String get name => 'Ім\'я';

  @override
  String get age => 'Вік';

  @override
  String get gender => 'Стать';

  @override
  String get male => 'Чоловіча';

  @override
  String get female => 'Жіноча';

  @override
  String get other => 'Інше';

  @override
  String get registerButton => 'Зареєструватися';

  @override
  String get haveAccount => 'Вже є акаунт? Увійдіть';

  @override
  String get home => 'Головна';

  @override
  String get sleep => 'Сон';

  @override
  String get food => 'Харчування';

  @override
  String get mood => 'Самопочуття';

  @override
  String get history => 'Історія';

  @override
  String get settings => 'Налаштування';

  @override
  String goodMorning(Object name) {
    return 'Доброго ранку, $name!';
  }

  @override
  String get howAreYou => 'Як справи з вашим здоров\'ям?';

  @override
  String get recordSleep => 'Записати сон';

  @override
  String get sleepSubtitle => 'Відзначте якість та тривалість\nвашого сну';

  @override
  String get recordFood => 'Записати харчування';

  @override
  String get foodSubtitle => 'Додайте інформацію про\nприйоми їжі';

  @override
  String get recordMood => 'Оцінити самопочуття';

  @override
  String get moodSubtitle => 'Як ви себе почуваєте?';

  @override
  String get recentRecords => 'Останні записи';

  @override
  String todayRecords(Object meals, Object sleep) {
    return 'Сьогодні: $sleep год сну, $meals прийоми їжі';
  }

  @override
  String get deleteConfirmation => 'Ви впевнені, що хочете видалити цей запис?';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get recordDeleted => 'Запис успішно видалено';

  @override
  String get recordDetails => 'Деталі запису';

  @override
  String get errorDeleting => 'Помилка видалення запису';

  @override
  String get saving => 'Збереження...';

  @override
  String get hours => 'год';
}
