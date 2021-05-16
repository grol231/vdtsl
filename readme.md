#Installation & run

1. `git clone git@github.com:kuzinmv/vdtsl.git`
2. `cd vdtsl`
3. `docker-compose build`
4. `docker-compose up -d`
5. wait  ...  wait ... wait ...
6. check logs `docker-compose logs`
7. `curl http://localhost/api/traffic/v1/area` should return `[]` not 502
8. if all ok ? then add 3 area Spb Omsk Vl
9. `curl http://localhost/api/traffic/v1/area -H "Content-Type:application/json" -X POST -d@app/mock/area1.json`
10. `curl http://localhost/api/traffic/v1/area -H "Content-Type:application/json" -X POST -d@app/mock/area2.json`
11. `curl http://localhost/api/traffic/v1/area -H "Content-Type:application/json" -X POST -d@app/mock/area3.json`
12. `curl http://localhost/api/traffic/v1/area` should return 3 area
13. `curl http://localhost/api/traffic/v1/area/reload`  4(or more) times, ensure that all upstream reloaded (3001, 3002, 3003, 3004)
14. now we ready to filter your requests. Lets try with mock 
15. `curl http://localhost/api/traffic/v1/probedata -H "Content-Type:application/json" -X POST -d @app/mock/test1.json -w "\n%{time_total}\n"`
16. Result ~ `{"total":2499} 0,035713`
17. All filtered points you may check in the `cd vdtsl/app/out` directory  