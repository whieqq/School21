# 7. Prometheus и Grafana

## Установка и настройка Prometheus

- Установка Prometheus:
  `sudo apt install -y prometheus`

- Проверка статуса
  ![status_prometheus](images/status_prometheus.png)

- Получим доступ к веб-интерфейсу Prometheus на своей локальной машине  
  `для этого на локальной машине пробросим порт 9090 на ВМ`  
  ![ssh_9090_prometheus](images/ssh_9090_prometheus.png)  
  `зайдем в веб-интерфейс с локальной машины`  
  ![web_prometheus](images/web_prometheus.png)  

## Установка и настройка Grafana

- Установка Grafana  
  `sudo apt-get install -y adduser libfontconfig1 musl`  
  `wget https://dl.grafana.com/grafana/release/13.2.3/grafana_13.2.3_36482603486_linux_amd64.deb`  
  `sudo dpkg -i grafana_13.2.3_36482603486_linux_amd64.deb`  

- Проверка статуса  
  ![status_grafana](images/status_grafana.png)  

- Получим доступ к веб-интерфейсу Grafana на своей локальной машине  
  `для этого на локальной машине пробросим порт 3000 на ВМ`  
  ![ssh_3000_grafana](images/ssh_3000_grafana.png)  
  `зайдем в веб-интерфейс с локальной машины`  
  ![web_grafana](images/web_grafana.png)  

- Дашборд `Grafana` отображающий ЦПУ, доступную оперативную память, свободное место и кол-во операций ввода/вывода на жестком диске  
  ![dashbord_system_overview](images/dashbord_system_overview.png)  
  
## Тесты

- Запустим bash скрипт из части 2, чтобы посмотреть на нагрузку жесткого диска (место на диске и операции чтения/записи)  
  ![run_bash1](images/run_bash1.png)

- Посмотрим как изменились показатели на дашборте в Grafana  
  ![metrics_grafana1](images/metrics_grafana1.png)  

- Проведем стресс-тест на ВМ  
  ![stress_test32_1](images/stress_test32_1.png)

- Посмотрим как изменились показатели на дашборте в Grafana  
  ![metrics_grafana2](images/metrics_grafana2.png)  

`Не сильно видно нагрузку на систему, т.к. на виртуалке 8GB оперативной памяти и 4 процессора. Чтобы тест выглядел нагляднее:`  
  
- сузим окно времени в Grafana  
- увеличим параметры для стресс-теста: stress -c 4 -i 2 -m 2 --vm-bytes 512M -t 60s  

  ![stress_test512_1](images/stress_test512_1.png)
  ![metrics_grafana3](images/metrics_grafana3.png)