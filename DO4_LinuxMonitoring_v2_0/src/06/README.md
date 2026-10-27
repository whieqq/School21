# 6. Анализ логов через GoAccess

- Установка GoAccess
  ![install_goaccess](images/goaccess.png)

- Формируем логи nginx
  ![create_logs_nginx](images/logs_nginx.png)

- Запустим GoAccess для отображения информации по логам
  ![start_goaccess](images/start_goaccess.png)

  - Информация по ошибкам (панель номер 13)
    ![info_errors](images/info_errors.png)

  - Информация по уникальным IP (панель номер 5)
    ![unique_ip](images/unique_ip.png)
  
  - Информация по запросам с ошибками
    ![ignore_2xx](images/ignore_2xx.png)
    ![info_only_errors](images/info_only_errors.png)

  - Информация по уникальным IP, которые встречаются среди ошибочных запросов (панель номер 5)
    ![unique_ip_among_erros](images/unique_ip_among_erros.png)

- Откроем веб-интерфейс на локальной машине  
  Так как мы запускаем все на ВМ в отчете будет показано как:
  1. сформировать отчет через GoAccess,
  2. запустить веб-сервер (обычный питоновский),
  3. пробросить порт через ssh-туннель
  4. посмотреть отчет GoAccess на основной локальной машине

1. Формируем отчет через GoAccess
   ![report_goaccess](images/report_goaccess.png)

2. Запускаем веб-сервер
   ![run_web_server](images/run_web_server.png)

3. Проброс локального порта 8081 на порт 8080 виртуальной машины через SSH-туннель
   ![ssh_tunnel](images/ssh_tunnel.png)

4. Веб-интерфейс GoAccess на основной машине
   ![web_interface](images/web_interface.png)

- Покажем туже информацию по ошибкам и IP в веб-интерфейсе
  
  - Информация по ошибкам
    ![web_errors](images/web_errors.png)

  - Информация по уникальным IP
    ![web_unique](images/web_unique.png)

  - Информация по запросам с ошибками
    ![report_only_errors](images/report_only_errors.png)
    ![web_only_errors](images/web_only_errors.png)

  - Информация по уникальным IP, которые встречаются среди ошибочных запросов
    ![web_unique_errors](images/web_unique_errors.png)
