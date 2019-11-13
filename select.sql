select z.*, hs.* from 
zahialga as z 
left join ( 
	select h.*, s.buteegdehuun_id from 
			hereglegch as h join 
            sags as s 
            on h.id = s.hereglegch_id) as hs
on z.hereglegch_id = hs.id;