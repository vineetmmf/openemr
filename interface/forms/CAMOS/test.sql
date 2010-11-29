		select t1.form_id, t1.form_name
	      	 from 
		forms as t1 join 
		form_encounter as t2 on 
		(t1.pid = t2.pid) 
		join patient_data as t3 on 
		(t2.pid = t3.pid) where 
		t1.encounter = t2.encounter and 
		date(t2.onset_date) like date(now()) 
		order by t2.date,t2.pid;
