const String tokenData = '{"token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjRsUTZwNDROZHdxaU5vSDJfTnItaG5HYUFNOGp4ZDRIdlVFUmZlbHI1dU0iLCJ0eXAiOiJKV1QifQ.eyJ0b2tlbl90eXBlIjoic2xpZGluZyIsImV4cCI6MTcwODM0Mzk1NCwiaWF0IjoxNzA4MTcxMTU0LCJqdGkiOiI2MmYxZmUwMzRlZWI0MjYxYTRlOTAxYWRmOWUxOTg5OSIsInJlZnJlc2hfZXhwIjoxNzA5MzgwNzU0LCJpc3MiOiJodHRwczovL2FwaS5teTI0c2VydmljZS5jb20vIiwidXNlcl90eXBlIjoic3VwZXJ1c2VyIiwidXNlcl9pZCI6IjJmMzQyNmEwLTFkZWYtNDc0MC1iNGQzLWFkMDIwN2IyY2FjNCJ9.FO0IZ3N3uBV22Iy_0Klo89Y7iqIyyANFWCit4zEBIeRvbnZo0OtfoUd8ldMGUBmDx3C9kwVQmJctaDzwDRUe9Gy_g2JFESoHtL_gExrxbt1_uZbp2iLqytKqAiRRHIkOSflpeAdN4OocZIYyLFs2cc3b0kHnkwfSXJbHTXfVt7zZUDru-raBN0v8VPiBPyVIVpJNMQMHfSJMP4kSWA19MQD8pLKpEQitcKlDyObY-ycYCpuO_bjPT5_6VNKolcO-nZGfeFe01LUyp4LmpLHXMRmpD7Bb3dGk-xAXXdGwYSDUQYYGV6gciMigUd3YHxcykUo8hgM7-drcbnCFW3gfX4DvJ4niyEmwCJivkN5t5qjtnYxOrLcuLRKl4apP-Nb8xlHnrPkdTdH0-KRf5iHsd-Wtu_L77iwdz5fz6R8s6vlz4HrGU0j-X_e15qJCwivIwqi8bzBAK9YKWLTmpckttWGn7DgzobX8gX29tSL1_ufDzusMD0r0RIWrb__CEPDdNv1t1kopPI3c2u6JByd2eYIQBkSmikwnOOGWB4Gm8BwdXN6v05CydTxIqXuIcBFrwtT7WSVeZRHpa6gWs8mrsYWrz6XwG20n8RoUtxh_5EumxEluuiutfAGYhz4oB25Csw2fVj7qOvaKXg6JALCbWRjlXL20q84dqMFAWA1NlWg"}';
const String order = '{"id":506,"uuid":"f194abef-04dc-4874-ac79-38b6c1204849","customer_id":"1263","order_id":"10603","service_number":null,'
    '"order_reference":"","order_type":"Onderhoud","customer_remarks":"","description":null,"start_date":"17/03/2023","start_time":null,'
    '"end_date":"17/03/2023","end_time":null,"order_date":"17/03/2023","last_status":"Workorder signed",'
    '"last_status_full":"17/03/2023 11:52 Workorder signed","remarks":null,"order_name":"Fictie B.V.","order_address":"Metaalweg 4",'
    '"order_postal":"3751LS","order_city":"Bunschoten-Spakenburg","order_country_code":"NL","order_tel":"0650008","order_mobile":"+31610344871",'
    '"order_email":null,"order_contact":"L. Welling","created":"15/03/2023 11:44","documents":[],"statusses":[{"id":1590,"order":506,'
    '"status":"Aangemaakt door planning","modified":"15/03/2023 11:44","created":"15/03/2023 11:44"},{"id":1594,"order":506,'
    '"status":"Opdracht toegewezen aan mv","modified":"17/03/2023 11:40","created":"17/03/2023 11:40"},{"id":1595,"order":506,'
    '"status":"Begin opdracht gemeld door mv","modified":"17/03/2023 11:40","created":"17/03/2023 11:40"},{"id":1596,"order":506,'
    '"status":"Opdracht klaar gemeld door mv","modified":"17/03/2023 11:43","created":"17/03/2023 11:43"},{"id":1597,"order":506,'
    '"status":"Workorder signed","modified":"17/03/2023 11:52","created":"17/03/2023 11:52"}],"orderlines":[{"id":1311,"product":"df",'
    '"location":"df","remarks":"df","price_purchase":"0.00","price_selling":"0.00","amount":0,"material_relation":null,'
    '"location_relation_inventory":null,"purchase_order_material":null}],'
    '"workorder_pdf_url":"https://demo.my24service-dev.com/media/workorders/demo/workorder-demo-10603.pdf","total_price_purchase":"0.00",'
    '"total_price_selling":"0.00","customer_relation":1167,"customer_rate_avg":null,"required_assigned":"1/1 (100.00%)","required_users":1,'
    '"user_order_available_set_count":0,"assigned_count":1,'
    '"workorder_url":"https://demo.my24service-dev.com/#/orders/orders/workorder/f194abef-04dc-4874-ac79-38b6c1204849",'
    '"workorder_pdf_url_partner":"","customer_order_accepted":true,"workorder_documents":[],"workorder_documents_partners":[],'
    '"infolines":[{"id":66,"info":"sd"}],"assigned_user_info":[{"full_name":"Melissa Vedder","license_plate":""}],'
    '"maintenance_product_lines":[],"reported_codes_extra_data":[],"branch":null}';
const String orderDocument = '{"id": 1, "order": 1, "name": "grappig.png", "description": "", "document": "grappig.png"}';
const String orderTypes = '["Storing","Reparatie","Onderhoud","Klein onderhoud","Groot onderhoud","2 verdiepingen","Trap mal"]';
const String memberSettings = '{"equipment_location_quick_create":false, "equipment_quick_create": false, "equipment_location_employee_quick_create": true, "equipment_location_planning_quick_create": true, "equipment_employee_quick_create": true, "equipment_planning_quick_create": true, "countries":["NL","BE","DE","LU","FR"],"customer_id_autoincrement":true,"customer_id_start":1000,"date_format":"%d/%m/%Y","dispatch_assign_status":"assigned to {{ active_user_username }}","equipment_employee_quick_create":true,"equipment_location_employee_quick_create":true,"equipment_location_planning_quick_create":true,"equipment_planning_quick_create":true,"leave_accepted_status":"leave accepted by {{ username }}","leave_change_status":"leave updated by {{ username }}","leave_entry_status":"leave created by {{ username }}","leave_rejected_status":"leave rejected by {{ username }}","order_accepted_status":"order accepted","order_change_status":"order updated by {{ username }}"}';
const String memberPublic = '{"id": 1, "companycode": "demo", "companylogo": "", "companylogo_url": "", "name": "demo", "address": "", "postal": "", "city": "", "country_code": "", "tel": "", "email": "", "has_branches": true}';
const String planningUser = '{"submodel": "planning_user", "user": {'
    '"id": 1, "email": "bla@bla.com", "username": "bla", "full_name": "", "first_name": "", "last_name": "",'
    '"planning_user": {}'
    '}}';
const String initialData = '{}';
const String myBranchData = '{"id":4,"name":"SHLTR group","address":"Metaalweg 4","postal":"3751LS","city":"Bunschoten-Spakenburg","country_code":"NL","tel":"033-2474020","email":"info@shltr-group.com","contact":"Wesley Buitenhuis","mobile":"","created":"24/02/2024 11:53","modified":"24/02/2024 11:53","num_orders":null}';
const String equipment = '{"id":1,"uuid":"c56ddfe1-f51b-4045-9d85-776e8ab0dcd4","customer":null,"branch":1,"customer_branch_view":{"id":1,"name":"Test B.V.","address":"Street 1","postal":"1234AB","city":"Utrecht","country_code":"NL","tel":null,"email":"donald@test.nl","contact":"Donald Trump","mobile":"","created":"16/01/2024 10:40","modified":"16/01/2024 10:40","num_orders":null},"location":null,"location_name":null,"name":"100 vriessnelloopdeur koelcel groot","brand":"Assa Abloy","identifier":null,"description":null,"installation_date":"2024-02-28","production_date":null,"serialnumber":null,"standard_hours":null,"default_replace_months":0,"latest_state":null,"price":"0.00","price_currency":"EUR","qr_path":"media/qr-codes/equipment/test/c56ddfe1-f51b-4045-9d85-776e8ab0dcd4.png?t=1709374009.2768633","created":"28/02/2024 11:52","modified":"28/02/2024 11:52"}';
const String ordersEmpty = '{"next":null,"previous":null,"count":0,"num_pages":0,"results":[]}';
