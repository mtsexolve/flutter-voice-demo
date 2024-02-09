# Exolve Flutter Voice Demo

## Зачем

Это приложение показывает возможности [Exolve Flutter Voice SDK](https://pub.dev/packages/exolve_voice_sdk) для интегрирования функциональности телефонных звонков в вашем приложении. В приложении можно принимать и инициировать телефонные звонки с помощью платформы [Exolve](https://exolve.ru). Для использования этой функциональности необходимо зарегистрироваться на платформе и получить логин и пароль для доступа к API.

## Предварительно настроенное окружение

Предполагается, что предварительно установлен flutter.

## Сборка приложения под iOS

1. Открыть проект ios/Runner.xcworkspace в Xcode
2. Добавить информацию во вкладке "Signing & Capabilities" о подписи приложения
3. Добавить "Push Notifications" во вкладке "Signing & Capabilities" через кнопку "+ Capability"
4. Можно начать собирать проект. Проект можно собрать и для симулятора и для телефона

## Сборка и запуск приложения под Android

1. Добавить в  ~/.gradle/gradle.properties авторизационные данные для GitHub:

```text
gpr.user=YOUR_GITHUB_USERNAME
gpr.key=YOUR_GITHUB_TOKEN
```

2. Выполнить команду

```text
flutter run --flavor google 
```
для сборки под Firebase либо

```text
flutter run --flavor huawei
```
для сборки под HMS.
