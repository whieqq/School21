# 8. Готовый дашборд Node Exporter

## Добавление дашборда Node Exporter Quickstart and Dashboard с официального сайта Grafana Labs

- Скачаем json файл по ссылке: https://grafana.com/api/dashboards/13978/revisions/2/download
- Добавим дашборд: `Dashboards` -> `New` -> `Import Dashboard` -> `Upload dashboard JSON file` -> `Import`
  ![node_exporter_dashboard](images/node_exporter_dashboard.png)  

## Тесты

- Запустим bash скрипт из части 2, чтобы посмотреть на нагрузку жесткого диска (место на диске и операции чтения/записи)  
  ![run_bash](images/run_bash.png)

- Посмотрим как изменились показатели на дашборте в Grafana  
  ![dashboard_grafana1](images/dashboard_grafana1.png)

- Проведем стресс-тест на ВМ  
  ![stress_test](images/stress_test.png)

- Посмотрим как изменились показатели на дашборте в Grafana  
  ![dashboard_grafana2](images/dashboard_grafana2.png)

`Не сильно видно нагрузку на систему, т.к. на виртуалке 8GB оперативной памяти и 4 процессора. Чтобы тест выглядел нагляднее:`  
  
- увеличим параметры для стресс-теста: stress -c 4 -i 2 -m 2 --vm-bytes 512M -t 60s  

  ![stress_test512_1](images/stress_test512_1.png)
  ![dashboard_grafana3](images/dashboard_grafana3.png)
  
- Проведем тест сетевого интерфейса  
  `На ВМ DO4-1 запустим iperf3 -s -i 0`  
  `На ВМ DO4-2 запустим iperf3 -c 192.168.0.149 -t 60 -P 5 -4 -i 0`  
  
  ![do4-1_iperf3_s](images/do4-1_iperf3_s.png)  
  ![do4-2_iperf3_c](images/do4-2_iperf3_c.png)  

- Итоги теста
  ![total_do4-1_iperf3_s](images/total_do4-1_iperf3_s.png)  
  ![totatl_do4-2_iperf3_c](images/totatl_do4-2_iperf3_c.png)  

- Показатели в дашборде Grafana  
  ![dashboard_grafana4](images/dashboard_grafana4.png)  
