var/global/list/obj/item/device/stalker_pda/KPKs = list()
var/global/global_lentahtml = ""

/obj/item/device/stalker_pda
	name = "KPK"
	desc = "A portable device, used to communicate with other stalkers."
	icon = 'icons/stalker/device_new.dmi'
	icon_state = "kpk_off"
	item_state = "kpk"
	w_class = 1

	var/mode = 1
	var/show_title = 0
	var/mainhtml = ""
	var/navbarhtml = ""
	var/ratinghtml =""
	var/list/access = list()

	//�������
	var/mob/living/carbon/human/owner = null
	var/registered_name = null
	var/sid = null
	var/rotation = "front"
	var/rus_faction_s = "��������"
	var/rating = 0
	var/reputation = 0
	var/money = 0
	var/obj/item/weapon/photo/photo_owner_front = new()
	var/obj/item/weapon/photo/photo_owner_west = new()
	var/obj/item/weapon/photo/photo_owner_back = new()
	var/obj/item/weapon/photo/photo_owner_east = new()
	var/password = null
	var/hacked = 0
	var/rep_color_s = "#ffe100"
	var/rep_name_s = "����������&#x44F;"
	var/eng_rep_name_s = "Neutral"
	var/rus_rank_name_s = "�������"
	var/eng_rank_name_s = "Rookie"
	var/eng_faction_s = "Loners"
	//var/isregistered = 0

	//�����
	var/lentahtml = ""
	var/lenta_sound = 1
	var/last_lenta = 0
	var/lenta_id = 0

	var/last_faction_lenta = 0
	var/lenta_faction_id = 0

	var/msg_name = "message"
	var/max_length = 10
	slot_flags = SLOT_ID

	//�������
	var/sortBy = "rating"
	var/order = 1
	var/lastlogin = 0

	//������������
	var/article_title = "Zone"
	var/article_text = "The Zone of Alienation is the 60 km wide area of exclusion that was set up around the Chernobyl NPP following the 1986 disaster and extended by the second Chernobyl disaster in 2006."
	var/article_img = "nodata.gif"
	var/article_img_width = 179
	var/article_img_height = 128

/datum/asset/simple/kpk
	assets = list(
		"kpk_background.png"	= 'icons/stalker/images/kpk.png',
		"nodata.png"			= 'icons/stalker/images/nodata.png',
		"photo_0"				= 'icons/stalker/images/sidor.png',
		//���� ��� ������������
		"zone"					= 'icons/stalker/images/zone.png',
		"backwater"				= 'icons/stalker/images/backwater.jpg',
		"nodata.gif"			= 'icons/stalker/images/nodata.gif',
		//�������
		"cursor"				= 'code/game/stalker/testunit_dev/cursors/StalkerCursor.ani',
		"cursorText"			= 'code/game/stalker/testunit_dev/cursors/sText.cur',
		"cursorWait"			= 'code/game/stalker/testunit_dev/cursors/Wait.ani'
	)


/obj/item/device/stalker_pda/New()
	..()
	return

/obj/item/device/stalker_pda/MouseDrop(atom/over_object)
	if(iscarbon(usr) || isdrone(usr)) //all the check for item manipulation are in other places, you can safely open any storages as anything and its not buggy, i checked
		var/mob/M = usr

		if(!M.restrained() && !M.stat)
			if(loc != usr || (loc && loc.loc == usr))
				return

			if(over_object)
				switch(over_object.name)
					if("r_hand")
						if(!M.unEquip(src))
							return
						M.put_in_r_hand(src)
					if("l_hand")
						if(!M.unEquip(src))
							return
						M.put_in_l_hand(src)
				add_fingerprint(usr)

/obj/item/device/stalker_pda/attack_hand(mob/living/user)
	if(src.loc == user)
		attack_self(user)
		user.set_machine(src)
	else
		..()

/obj/item/device/stalker_pda/attack_self(mob/user)
	if(!istype(user, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = user

	if(owner == H)
		var/datum/data/record/sk = find_record("sid", H.sid, data_core.stalkers)
		if(!sk)
			owner = null
		else
			set_owner_info(sk)
			sk.fields["lastlogin"] = world.time

	icon_state = "kpk_on"
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/kpk)
	assets.send(user)

	/*
	<style>\
		a:link {color: #607D8B;}\
		a:visited {color: #607D8B;}\
		a:active {color: #607D8B;}\
		a:hover {background-color: #9E9E9E;}\
		a {text-decoration: none;}\
		body {\
		background-image: url('kpk_background.png');\
		padding-top: 18px;\
		padding-left: 35px;\
	*/

	user.set_machine(src)
	mainhtml ="<html> \
	\
	<style>\
		a:link {color: #607D8B;}\
		a:visited {color: #607D8B;}\
		a:active {color: #607D8B;}\
		a:hover {\
		background-color: #9E9E9E;\
		cursor: url('cursor');\
	}\
	a {text-decoration: none;}\
	html {cursor: url('cursor');}\
	body {\
		background-image: url('kpk_background.png');\
		padding-top: 18px;\
		padding-left: 35px;\
	}\
	table {\
		background: #131416;\
		padding: 15px;\
		margin-bottom: 10px;\
		color: #afb2a1;\
	}\
	\
	#table-bottom1 {\
		background: #2e2e38;\
		padding-top: 5px;\
		padding-bottom: 5px;\
	}\
	#table-center1 {\
		position: relative;\
		background: #2e2e38;\
		padding-top: 5px;\
		padding-bottom: 5px;\
		bottom: 100px;\
	}\
	#table-center2 {\
		position: relative;\
		background: #2e2e38;\
		bottom: 0px;\
	}\
	#table-lenta {\
		background: #9E9E9E;\
	}\
	div.relative {\
		position: relative;\
		width: 250px;\
		height: 200px;\
		top: 70px;\
	}\
	\
	#lenta {\
		background: #2e2e38;\
		color: white;\
		padding: 5px;\
		width: 449px;\
		height: 228px;\
		overflow: auto;\
		border: 1px solid #ccc;\
		word-wrap: break-word;\
	}\
	p.lentamsg {\
		margin: 0px;\
		word-wrap: break-word;\
	}\
	#navbar {\
		overflow: hidden;\
		background-color: #099;\
		position: fixed;\
		top: 0;\
		width: 100%;\
		padding-top: 3px;\
		padding-bottom: 3px;\
		padding-left: 20px;\
	}\
	#navbar a {\
		float: left;\
		display: block;\
		color: #666;\
		text-align: center;\
		padding-right: 20px;\
		text-decoration: none;\
		font-size: 17px;\
	}\
	#navbar a:hover {\
		background-color: #ddd;\
		color: black;\
	}\
	#navbar a.active {\
		background-color: #4CAF50;\
		color: white;\
	}\
	#ratingimg {\
		vertical-align:middle;\
	}\
	.main {\
	}\
	.main img {\
		height: auto;\
	}\
	.button {\
		width: 300px;\
		height: 60px;\
	}\
	#encyclopedia_table {\
		background: #131416;\
		padding: 0px;\
		margin-bottom: 0px;\
		color: #afb2a1;\
		margin-left: 0px;\
	}\
	#encyclopedia_list {\
		background: #2e2e38;\
		color: #afb2a1;\
		padding: 5px;\
		width: 160px;\
		height: 228px;\
		overflow: auto;\
		border: 1px solid #ccc;\
		word-wrap: break-word;\
		margin-left: 3px;\
	}\
	#encyclopedia_list li{\
		list-style-type: none;\
		height: 0em;\
		margin-left : 0px;\
	}\
	#encyclopedia_list li ul{\
		visibility: hidden;\
		height: 0em;\
		margin-left : 0px;\
	}\
	#encyclopedia_list li ul li{\
		height: 0em;\
		margin-left : 0px;\
	}\
	#encyclopedia_info {\
		background: #2e2e38;\
		color: #afb2a1;\
		padding: 0px;\
		padding-left: 5px;\
		width: 273px;\
		height: 228px;\
		overflow: auto;\
		border: 1px solid #ccc;\
		word-wrap: break-word;\
		margin-right : 0px;\
	}\
	</style>"
	if (!owner || !password)
		mainhtml +="<body>\
		<table border=0 height=\"314\" width=\"455\">\
		<tr>\
		<td valign=\"top\" align=\"center\">\
		<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div><br>\
		<div class=\"relative\" align=\"center\">"


		if(user.client && (user.client.prefs.chat_toggles & CHAT_LANGUAGE))
			mainhtml += "ENTER THE PASSWORD"
		else
			mainhtml += "������� ������"

		mainhtml +="\
		</div>\
		</td>\
		</tr>\
		<tr>\
		<td colspan=\"2\" align=\"center\" id=\"table-center1\" height=60>\
				| <a style=\"color:#c10000;\" href='byond://?src=\ref[src];choice=password_input'>_______________</a> |<br>\
		<div align=\"center\"></div>\
		</td>\
		</tr>"
	else

		if (user != owner && hacked == 0)
			mainhtml +="<body>\
			\
			<table border=0 height=\"314\" width=\"455\">\
			<tr>\
			<td align=\"left\" width=200>\
			<div style=\"overflow: hidden; height: 200px; width: 180px;\" ><img height=80 width=80 border=4 src=photo_front><img height=80 width=80 border=4 background src=photo_side></div>\
			</td>\
			<td valign=\"top\" align=\"left\">\
			 <div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div><br>"

			if(user.client && (user.client.prefs.chat_toggles & CHAT_LANGUAGE))
				mainhtml +="\
				 <b>Name:</b> [owner.real_name]<br><br>\
				 <b>Faction:</b> [eng_faction_s]<br><br>\
				 <b>Rank:</b> [rating]<br><br>\
				 <b>Reputation:</b> <font color=\"[rep_color_s]\">[eng_rep_name_s]</font>"
			else
				mainhtml +="\
				 <b>��&#x44F;:</b> [owner.real_name]<br><br>\
				 <b>�����������:</b> [rus_faction_s]<br><br>\
				 <b>����:</b> [rating]<br><br>\
				 <b>��������&#x44F;:</b> <font color=\"[rep_color_s]\">[rep_name_s]</font>"


			 mainhtml +="\
			 \
			</td>\
			</tr>\
			\
			<tr>\
			<td colspan=\"2\" align=\"center\" id=\"table-bottom1\" height=60>\
				| <a style=\"color:#c10000;\" href='byond://?src=\ref[src];choice=password_check'>� ������� �������� - ������� ������</a> |<br>\
			<div align=\"center\"></div>\
			</td>\
			</tr>"
		else
			switch(mode)

		//�������

				if(1)
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						navbarhtml ="| <a>Profile</a> | <a href='byond://?src=\ref[src];choice=2'>Encyclopedia</a> | <a href='byond://?src=\ref[src];choice=3'>Rating</a> | <a href='byond://?src=\ref[src];choice=4'>Feed</a> | <a href='byond://?src=\ref[src];choice=5'>Map</a> |<br>"
					else
						navbarhtml ="| <a>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>"

					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
						<tr>\
							<td valign=\"top\" align=\"left\">"
					if(user.client && (user.client.prefs.chat_toggles & CHAT_LANGUAGE))
						mainhtml +="\
						<div align=\"right\"><a style=\"color:#c10000;\" align=\"center\" href='byond://?src=\ref[src];choice=exit'>\[EXIT\]</a><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
						<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=rotate'>Rotate photo</a> | <a href='byond://?src=\ref[src];choice=make_avatar'>Change profile photo</a> | </div>"
					else
						mainhtml +="\
						<div align=\"right\"><a style=\"color:#c10000;\" align=\"center\" href='byond://?src=\ref[src];choice=exit'>\[�����\]</a><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
						<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=rotate'>��������� ���� ������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=make_avatar'>������� ���� ������&#x44F;</a> | </div>"

					mainhtml +="\
							</td>\
							</tr>\
							<tr valign=\"top\">\
							<td>\
								<table>\
									<tr>\
					<td style=\"text-align: center;\" valign=\"top\" align=\"left\" width=90 height=90>\
					<img style=\"margin-left: auto; margin-right: auto;\" height=80 width=80 border=4 src=photo_[rotation]>\
					<br>\
					</td>\
					<td>"
					if(user.client && (user.client.prefs.chat_toggles & CHAT_LANGUAGE))
						mainhtml+="\
					<b>Name:</b> [owner.real_name]<br>\
					<b>Faction:</b> [eng_faction_s]<br>\
					<b>Rank:</b> [eng_rank_name_s] ([rating])<br>\
					<b>Reputation:</b> <font color=\"[rep_color_s]\">[eng_rep_name_s] ([reputation])</font><br>\
					<b>Money:</b> [money] RU<br>"

					else
						mainhtml+="\
					<b>��&#x44F;:</b> [owner.real_name]<br>\
					<b>�����������:</b> [rus_faction_s]<br>\
					<b>����:</b> [rus_rank_name_s] ([rating])<br>\
					<b>��������&#x44F;:</b> <font color=\"[rep_color_s]\">[rep_name_s] ([reputation])</font><br>\
					<b>������ �� �����:</b> [money] RU<br>"

					mainhtml +="\
					</td>\
					</tr>\
				</table>\
			</td>\
		</tr>"

		//������������

				if(2)
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>Profile</a> | <a>Encyclopedia</a> | <a href='byond://?src=\ref[src];choice=3'>Rating</a> | <a href='byond://?src=\ref[src];choice=4'>Feed</a> | <a href='byond://?src=\ref[src];choice=5'>Map</a> |<br>"
					else
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>"

					mainhtml +="\
					<body>\
						<table border=0 height=\"314\" width=\"455\">\
							<tr>\
								<td valign=\"top\" align=\"left\">\
									<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
								</td>\
							</tr>\
							<tr style=\"border: 0px;\" valign=\"top\" align=\"left\">\
								<td valign=\"top\" align=\"left\">\
									<table id=\"encyclopedia_table\" align=\"left\">\
										<tr align=\"left\">\
											<td align=\"left\">\
												<div id=\"encyclopedia_list\">\
													<h3 style=\"margin-top:0px;margin-bottom:0px\"><a href='byond://?src=\ref[src];choice=2;page=Zone'>Zone</a></h4>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Backwater'>Backwater</a><br>\
													<h3 style=\"margin-top:0px;margin-bottom:0px\"><a href='byond://?src=\ref[src];choice=2;page=Anomalies'>Anomalies</a></h4>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Electro'>Electro</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Vortex'>Vortex</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Whirligig'>Whirligig</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Burner'>Burner</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Fruit Punch'>Fruit Punch</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Burnt Fuzz'>Burnt Fuzz</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Radiation'>Radiation</a><br>\
													<h3 style=\"margin-top:0px;margin-bottom:0px\"><a href='byond://?src=\ref[src];choice=2;page=Mutants'>Mutants</a></h4>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Blind Dog'>Blind Dog</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Flesh'>Flesh</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Snork'>Snork</a><br>\
													<a style=\"margin-left:10px\" href='byond://?src=\ref[src];choice=2;page=Boar'>Boar</a><br>\
													<h3 style=\"margin-top:0px;margin-bottom:0px\"><a href='byond://?src=\ref[src];choice=2;page=Artifacts'>Artifacts</a></h4>\
												</div>\
											</td>\
											<td valign=\"top\">\
												<div id=\"encyclopedia_info\">\
													<h4 style=\"margin:0px\">[article_title]</h4><br>\
													<img style=\"width:[article_img_width];height:[article_img_height];margin-bottom:0px;margin-top:0px;margin-left:10px\" src=[article_img]><br>\
													<p style=\"margin-left:10px\">[article_text]</p>\
												</div>\
											</td>\
										</tr>\
									</table>\
								</td>\
							</tr>"

		//�������

				if(3)
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>Profile</a> | <a href='byond://?src=\ref[src];choice=2'>Encyclopedia</a> | <a>Rating</a> | <a href='byond://?src=\ref[src];choice=4'>Feed</a> | <a href='byond://?src=\ref[src];choice=5'>Map</a> |<br>"
					else
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>"

					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
						<tr>\
							<td valign=\"top\" align=\"left\">\
								<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>"
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						mainhtml +="\
						<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=refresh_rating'>Refresh stalker list</a> | </div>"
					else
						mainhtml +="\
						<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=refresh_rating'>�������� ������ ���������</a> | </div>"
					mainhtml +="\
							</td>\
						</tr>\
						<tr valign=\"top\">\
							<td>\
								<div id= \"lenta\">\
								[ratinghtml]\
								</div>\
							</td>\
						</tr>"

		//�����

				if(4)
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>Profile</a> | <a href='byond://?src=\ref[src];choice=2'>Encyclopedia</a> | <a href='byond://?src=\ref[src];choice=3'>Rating</a> | <a>Feed</a> | <a href='byond://?src=\ref[src];choice=5'>Map</a> |<br>"
					else
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>"

					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>"
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						mainhtml +="\
						<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=lenta_add'>Send feed message</a> | <a href='byond://?src=\ref[src];choice=lenta_faction_add'>Send faction message</a> | <a href='byond://?src=\ref[src];choice=lenta_sound'>Turn on/off sound</a> |</div>"
					else
						mainhtml +="\
						<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=lenta_add'>�������� � �����</a> | <a href='byond://?src=\ref[src];choice=lenta_faction_add'>�������� �����������</a> | <a href='byond://?src=\ref[src];choice=lenta_sound'>���/���� ����</a> |</div>"
					mainhtml +="\
					</td>\
					</tr>\
					<tr style=\"border: 0px;\" valign=\"top\">\
					<td style=\"border: 0px;\">\
					<div id=\"lenta\">"
					mainhtml +="[lentahtml]\
					</div>\
					</td>\
					</tr>"

		//�����

				if(5)
					if(user.client.prefs.chat_toggles & CHAT_LANGUAGE)
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>Profile</a> | <a href='byond://?src=\ref[src];choice=2'>Encyclopedia</a> | <a href='byond://?src=\ref[src];choice=3'>Rating</a> | <a href='byond://?src=\ref[src];choice=4'>Feed</a> | <a>Map</a> |<br>"
					else
						navbarhtml ="| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a>�����</a> |<br>"

					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\">\
					<a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
					<div align = \"center\">\
					| <a href='byond://?src=\ref[src];choice=zoom' onclick=\"zoomin()\"> Zoom In</a> | \
					<a href='byond://?src=\ref[src];choice=zoom' onclick=\"zoomout()\"> Zoom Out</a> | \
					</div>\
					</td>\
					</tr>\
					<tr valign=\"top\">\
					<td>\
					<div id=\"lenta\">\
					<div class=\"main\">"
					if(user.z != 1)
						mainhtml += "<img id=\"map\" height=415 width=415 src=minimap_[user.z].png>"
					else
						mainhtml += "<img id=\"map\" height=415 width=415 src=nodata.png>"
					mainhtml +="\
					</div>\
					</div>\
					</td>\
					</tr>"

			mainhtml +="\
			<tr>\
				<td colspan=\"1\" align=\"center\" id=\"table-bottom1\" height=30>\
					[navbarhtml]\
					<div align=\"center\"></div>\
				</td>\
			</tr>"
	mainhtml +="\
	<table>\
	<script>\
	function toggleShowHide(id){\
		var d = document.getElementById(id);\
		d.style.visibility = (d.style.visibility == \"visible\") ? \"hidden\" : \"visible\";\
		d.style.height = (d.style.height == \"auto\") ? \"0em\" : \"auto\";\
	}\
	function zoomin(){\
		var myImg = document.getElementById(\"map\");\
		var currWidth = myImg.clientWidth;\
		if(currWidth >= 1015) return false;\
		else{\
			myImg.style.width = (currWidth + 200) + \"px\";\
		} \
	}\
	function zoomout(){\
		var myImg = document.getElementById(\"map\");\
		var currWidth = myImg.clientWidth;\
		if(currWidth <= 415) return false;\
		else{\
			myImg.style.width = (currWidth - 200) + \"px\";\
		}\
	}\
	</script>\
	</body>\
	\
	</html>"
	if(show_title)
		user << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=1")
	else
		user << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=0")

/obj/item/device/stalker_pda/Topic(href, href_list)
	..()

	//var/mob/living/U = usr
	var/mob/living/carbon/human/H = usr
	var/isregistered = 0
	if(usr.canUseTopic(src))
		add_fingerprint(H)
		H.set_machine(src)
		switch(href_list["choice"])
			if("title")
				if(show_title)
					H << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=0")
					show_title = 0
				else
					H << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=1")
					show_title = 1

			if("close")
				icon_state = "kpk_off"
				H.unset_machine()
				hacked = 0
				H << browse(null, "window=mainhtml")
				return

			if("password_input")
				var/t = message_input(H, "password", 10)

				if(t)
					for(var/datum/data/record/sk in data_core.stalkers)
						if(sk.fields["sid"] == H.sid)
							isregistered = 1
					if(!isregistered)
						password = t
						var/pass = password

						data_core.manifest_inject(H, pass)

						//var/datum/job/J = SSjob.GetJob(H.job)
						//access = J.get_access()

						registered_name = H.real_name
						owner = H
						sid = H.sid
						lentahtml = global_lentahtml

						var/image = get_id_photo(H)
						var/obj/item/weapon/photo/owner_photo_front = new()
						var/obj/item/weapon/photo/owner_photo_west = new()
						var/obj/item/weapon/photo/owner_photo_east = new()
						var/obj/item/weapon/photo/owner_photo_back = new()

						owner_photo_front.photocreate(null, icon(image, dir = SOUTH))
						owner_photo_west.photocreate(null, icon(image, dir = WEST))
						owner_photo_east.photocreate(null, icon(image, dir = EAST))
						owner_photo_back.photocreate(null, icon(image, dir = NORTH))

						H << "<B>������ � ���</B>: <span class='danger'>\"[pass]\"</span>"
						H.mind.store_memory("<b>������ � ���</b>: \"[pass]\"")
						KPKs += src
						KPK_mobs += H

						for(var/datum/data/record/sk in data_core.stalkers)
							if(H.sid == sk.fields["sid"])
								set_owner_info(sk)
					else
						for(var/datum/data/record/sk in data_core.stalkers)
							if(sk.fields["sid"] == H.sid)
								if(sk.fields["pass"] == t)
									password = t
									//var/datum/job/J = SSjob.GetJob(H.job)
									//access = J.get_access()

									registered_name = H.real_name
									eng_faction_s = sk.fields["faction"]
									rating = sk.fields["rating"]
									owner = H
									sid = H.sid
									if(!lentahtml)
										lentahtml = global_lentahtml

									var/image = get_id_photo(H)
									var/obj/item/weapon/photo/owner_photo_front = new()
									var/obj/item/weapon/photo/owner_photo_west = new()
									var/obj/item/weapon/photo/owner_photo_east = new()
									var/obj/item/weapon/photo/owner_photo_back = new()

									owner_photo_front.photocreate(null, icon(image, dir = SOUTH))
									owner_photo_west.photocreate(null, icon(image, dir = WEST))
									owner_photo_east.photocreate(null, icon(image, dir = EAST))
									owner_photo_back.photocreate(null, icon(image, dir = NORTH))

									KPKs += src

									set_owner_info(sk)
								else
									H << "<span class='warning'>�������� ������.</span>"
				else
					H << "<span class='warning'>��� ������ �� ��������. ������� ������ ��� ���.</span>"

			if("exit")
				registered_name = null
				eng_faction_s = null
				rus_faction_s = null
				rating = null
				owner = null
				money = 0
				photo_owner_front = null
				photo_owner_west = null
				photo_owner_east = null
				photo_owner_back = null
				KPKs -= src
				hacked = 0
				password = null

			if("password_check")
				var/t = message_input(H, "password", 10)
				if(t == password)
					//hacked = 1
					hacked = 0
					H << "<span class='warning'>�� �� �������� ���.</span>"
				else
					H << "<span class='warning'>�������� ������.</span>"

			if("rotate")
				switch(rotation)
					if ("front")
						rotation = "west"
					if("west")
						rotation = "back"
					if("back")
						rotation = "east"
					if("east")
						rotation = "front"

			if("make_avatar")
				make_avatar(H)
				for(var/datum/data/record/sk in data_core.stalkers)
					if(H.sid == sk.fields["sid"])
						set_owner_info(sk)

			if("lenta_add")
				var/t = message_input(H, "message", 250)
				if(!t)
					if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
						H << "<span class='warning'>Enter the message!</span>"
					else
						H << "<span class='warning'>������� ���������!</span>"
				else
					if ( !(last_lenta && world.time < last_lenta + 450) )
						last_lenta = world.time

						add_lenta_message(src, sid, owner.real_name, eng_faction_s, t)

					else
						if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
							H << "<span class='warning'>You can't send messages in next [round((450 + last_lenta - world.time)/10)] sec.</span>"
						else
							H << "<span class='warning'>�� ������� ��������� ��������� ��������� �����: [round((450 + last_lenta - world.time)/10)] ���.</span>"

			if("lenta_faction_add")
				var/t = message_input(H, "message", 500)
				if(!t)
					if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
						H << "<span class='warning'>Enter the message!</span>"
					else
						H << "<span class='warning'>������� ���������!</span>"
				else
					if ( !(last_faction_lenta && world.time < last_faction_lenta + 450) )
						last_faction_lenta = world.time
						add_faction_lenta_message(src, sid, owner.real_name, eng_faction_s, t)

					else
						if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
							H << "<span class='warning'>You can't send messages in next [round((450 + last_faction_lenta - world.time)/10)] sec.</span>"
						else
							H << "<span class='warning'>�� ������� ��������� ��������� ��������� �����: [round((450 + last_faction_lenta - world.time)/10)] ���.</span>"

			if("lenta_sound")
				lenta_sound = !lenta_sound
				if(lenta_sound)
					if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
						H << "<span class='notice'>���� ���������&#255; � ��������&#255;� � ����� �����������.</span>"
					else
						H << "<span class='notice'>Feed sound turned on.</span>"
				else
					if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
						H << "<span class='notice'>Feed sound turned off.</span>"
					else
						H << "<span class='notice'>���� ���������&#255; � ��������&#255;� � ����� ��������.</span>"

			if("refresh_rating")
				ratinghtml = ""
				if(!isnull(data_core.stalkers))
					refresh_rating(H)

			if("zoom")
				return

			if("1")			//�������
				for(var/datum/data/record/sk in data_core.stalkers)
					if(H.sid == sk.fields["sid"])
						set_owner_info(sk)
				mode = 1

			if("2")			//������������
				mode = 2
				if(href_list["page"])
					if(H.client.prefs.chat_toggles & CHAT_LANGUAGE)
						switch(href_list["page"])
							if("Zone")
								article_title = "Zone"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "The Zone of Alienation is the 60 km wide area of exclusion that was set up around the Chernobyl NPP following the 1986 disaster and extended by the second Chernobyl disaster in 2006."

							if("Backwater")
								article_title = "Backwater"
								article_img = "backwater"
								article_img_width = 200
								article_img_height = 125
								article_text = "Backwater, also called Zaton, is mainly set in a swampy area, with a few industrial factories scattered around it and derelict, grounded boats, some dating back before the incident. From the outlying structures and sizable number of grounded boats and tankers around, Backwater appears to have been drained of its water sometime after the Chernobyl incident, most likely to contain the radiation contamination in the water. A free bar for Stalkers is run by Beard, in the wreck of a tanker � the Skadovsk."

							if("Anomalies")
								article_title = "Anomalies"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "After the second Chernobyl disaster, the Zone was littered with spots where the laws of nature and physics had been corrupted. These small oddities are called anomalies. They are hazardous, often deadly, towards human beings and other creatures as they can deliver electric shocks or burn, corrode and distort physical objects. Most anomalies produce visible air or light distortions, so their extent can be determined by throwing anything that is made of metal, like bolts, to trigger them. The anomalies seem to emit a powerful magnetic field, so it is logical to assume that the anomalies are triggered by anything made of metal that enters the magnetic field. Because vertebrate life on earth has iron-based blood, those creatures with enough body mass are capable of triggering the anomalies."

							if("Electro")
								article_title = "Electro"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "An anomalous formation, roughly 10 meters in diameter, accumulating large quantities of static electricity. When triggered, the anomaly bursts into a storm of arcing electricity nearly always lethal to all living beings. Easily recognizable by the blue gas it emits, along with the endless arcing of small bolts of electricity in the vicinity, the Electro holds no distinction for what crosses its event horizon, be it a human, a mutants or an inanimate object, and discharges as soon as anything gets too close."

							if("Vortex")
								article_title = "Vortex"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "An anomaly of presumably gravitational nature. When triggered, the tremendous power of the Vortex drags everything within the radius 10-15 meters towards the center. Victims drawn into the core have little to no chance of survival: their bodies are quickly constricted into a tight lump, only to be blown up in a powerful discharge of energy a moment later. In some cases, they may levitate in air with agony, and soon their entire systems are shredded into mere skeletal and flesh parts."

							if("Whirligig")
								article_title = "Whirligig"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "A common and dangerous anomaly, which snatches its victims up in the air and spins them at a breakneck speed. The exact nature of the Whirligig remains unknown. The anomaly can be recognized by a light whirlwind of dust above and by body fragments scattered in the vicinity. Victims caught on its outer rim, far enough from the maximum effect zone at the center, can escape the Whirligig with relatively minor injuries."

							if("Burner")
								article_title = "Burner"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "The Burner can be a bit difficult to see, even in daylight, as it's only revealed by a faint heat haze. If the anomaly is triggered by either a living being or an object such as a metal bolt, it shoots out a tall pillar of flame in the air, burning everything in its vicinity. Though somewhat rare, the Burner anomaly is often found in clusters. Some clusters also emit extreme high ambient temperature, which hurts anything in their vicinity. Burners can emit temperatures as low as 100 degrees Celsius, up to several thousand, hot enough to crack concrete and melt metal, which explains why some Burners appear in areas that have massive cracks and severe damaged soil, while other sites are untouched."

							if("Fruit Punch")
								article_title = "Fruit Punch"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "The Fruit Punch is a puddle of lambent green liquid that is easily visible in almost any environment due to its bright glow and distinctive hissing and bubbling noises. On contact with creatures or objects such as bolts, a Fruit Punch lights up brightly and emits a sharp hissing sound. It is extremely corrosive, damaging creatures and objects on contact. Any matter left in a Fruit Punch will eventually dissolve, hinting at the anomaly's corrosive nature and spelling doom for any protective suit."

							if("Burnt Fuzz")
								article_title = "Burnt Fuzz"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "This anomaly is usually found outdoors. It resembles moss or vines, hanging down like curtains from its growing spot. Reacts to rapidly approaching living beings by discharging a cloud of projectiles severely injuring uncovered or lightly protected skin upon contact. Does not react to slowly moving targets. Burnt Fuzz is generally considered the least dangerous anomaly in the Zone since it can be easily spotted and avoided."

							if("Radiation")
								article_title = "Radiation"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "Pockets of ionizing radiation, or simply radiation for short (areas where the ambient radiation count exceeds 50 mR per hour) can be found all over the Zone. In the outside areas, radiation tends to be dominant in wide, open spaces and on piles of scrap (such as the dirt or scrap piles in Garbage. Also cars, tractors and anything mechanical). Radiation in itself doesn't form artifacts. When you have accumulated enough radiation, you'll start to lose health; although radiation will decrease by itself (albeit very slowly) when you're outside of a radioactive area, it's often a good idea to use either Vodka, antirads, or a first aid kit to speed up the process."

							if("Mutants")
								article_title = "Mutants"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "Mutants are animals or humans who have been warped by the Zone, changing both their physical appearance and behavior, usually making them more aggressive."

							if("Blind Dog")
								article_title = "Blind Dog"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "Several generations of the dog species have lived and died since the catastrophe. Each was more affected by the Zone than the previous one. Rapid mutation lead to a vast improvement in previously peripheral abilities, frequently at the expense of primary ones. The most notable biological change was the loss of sight, paired with an uncanny development of smell. As it turned out, blind pups survived in the Zone as well as normal ones, if not better. As a result, the common dog quickly became extinct in the Zone, giving way to a new breed � that of blind dogs. The animals instinctively identify and avoid anomalies, radiation, and other invisible dangers that plague the Zone. Like their wild ancestors � the wolves � blind dogs hunt in packs. An encounter with a large group of these animals can be dangerous even to an experienced and well-armed stalker."

							if("Flesh")
								article_title = "Flesh"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "Like many other living creatures, domestic pigs in The Zone underwent serious mutations following the second Chernobyl disaster, affecting genes responsible for their metabolism. This eventually caused the animal's phenotype to change significantly."

							if("Snork")
								article_title = "Snork"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "The Snork is a horrifically mutated human soldier or Stalker, still wearing tattered remains of his uniform, boots and a GP-4 gas mask with cracked eyepieces, and a flailing hose. Exposure to radiation and anomalies in the wake of the second Chernobyl disaster has destroyed the human mind, leaving a feral, vicious beast psyche and a twisted body in its place, creating a dangerous predator."

							if("Boar")
								article_title = "Boar"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "Mutagenic processes engineered by radiation and anomalies have played a significant part in shaping these mammals: they have lost all fur in a few places and grown long, bristly fur in others. The animal's hooves have changed in shape and become sharper, acquiring a resemblance to claws. Also, their pupils have become colorless, while both pigmentation disorders and deep wrinkles have appeared on their bald heads. They have also grown an extra pair of tusks which are easily recognized."

							if("Artifacts")
								article_title = "Artifacts"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = "Artifacts are items that have been changed by the conditions in the Zone. Most artifacts have strange and useful characteristics. For example, when kept close to the body, some artifacts create a protective field that increases its user's resilience to damage. Others may increase the user's stamina or protect against fire, etc. Artifacts are also valuable scientific study material and outside corporations would pay a hefty price to obtain one of these artifacts from the zone."

							if("Artifacts")
								article_title = "Artifacts"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = ""

							if("Artifacts")
								article_title = "Artifacts"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = ""

							if("Artifacts")
								article_title = "Artifacts"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = ""

							if("Artifacts")
								article_title = "Artifacts"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = ""

							if("Artifacts")
								article_title = "Artifacts"
								article_img = "nodata.gif"
								article_img_width = 179
								article_img_height = 128
								article_text = ""






			if("3")			//�������
				if(!isnull(data_core.stalkers))
					refresh_rating(H)
				mode = 3

			if("4")			//�����
				for(var/datum/data/record/R in data_core.stalkers)
					if(R.fields["lastlogin"] + 18000 <= world.time)
						var/sid_p = R.fields["sid"]
						var/obj/item/weapon/photo/P1 = R.fields["photo_front"]
						H << browse_rsc(P1.img, "photo_[sid_p]")
				mode = 4

			if("5")			//�����
				SSminimap.sendMinimaps(H)
				mode = 5

		usr.set_machine(src)
		updateSelfDialog()
		return
	else
		hacked = 0
		H.unset_machine()
		H << browse(null, "window=mainhtml")

/obj/item/device/stalker_pda/proc/message_input(mob/living/U = usr, msg_name, max_length)
	var/t = sanitize_russian(stripped_input(U, "Please enter the [msg_name]", name, null, max_length), 1)
	if (!t)
		return
	if (!in_range(src, U) && loc != U)
		return
	if(!U.canUseTopic(src))
		return
	return t

/proc/add_lenta_message(var/obj/item/device/stalker_pda/KPK_owner, var/sid_owner, var/name_owner, var/faction_owner, msg, selfsound = 0)
	var/factioncolor 	= get_faction_color(faction_owner)
	global_lentahtml = "<table style=\"margin-top: 0px; margin-bottom: 5px; border: 0px; background: #2e2e38;\">\
		<tr style=\"border: 0px solid black;\">\
		<td style=\"border: 0px solid black; vertical-align: top; background: #2e2e38;\" width=32 height=32>\
		<img id=\"ratingbox\" style=\"background: #2e2e38; border: 1px solid black;\" height=32 width=32 src=photo_[sid_owner]>\
		</td>\
		\
		<td width=386 height=32 align=\"top\" style=\"background: #131416; border: 0px; text-align:left; vertical-align: top;\">\
		\
		<p class=\"lentamsg\"><b><font color = \"[factioncolor]\">[name_owner]\[[faction_owner]\]</font></b>:<br><font color = \"#afb2a1\">[msg]</font></p>\
		\
		</td>\
		\
		</tr>\
		</table>" + global_lentahtml

	for(var/obj/item/device/stalker_pda/KPK in KPKs)
		KPK.lentahtml = "<table style=\"margin-top: 0px; margin-bottom: 5px; border: 0px; background: #2e2e38;\">\
		<tr style=\"border: 0px solid black;\">\
		<td style=\"border: 0px solid black; vertical-align: top; background: #2e2e38;\" width=32 height=32>\
		<img id=\"ratingbox\" style=\"background: #2e2e38; border: 1px solid black;\" height=32 width=32 src=photo_[sid_owner]>\
		</td>\
		\
		<td width=386 height=32 align=\"top\" style=\"background: #131416; border: 0px; text-align:left; vertical-align: top;\">\
		\
		<p class=\"lentamsg\"><b><font color = \"[factioncolor]\">[name_owner]\[[faction_owner]\]</font></b>:<br><font color = \"#afb2a1\">[msg]</font></p>\
		\
		</td>\
		\
		</tr>\
		</table>" + KPK.lentahtml
		show_lenta_message(KPK_owner, KPK, sid_owner, name_owner, faction_owner, msg)
	show_dead_lenta_message(KPK_owner, name_owner, faction_owner, msg, isfactionchat = 0)
	//var/eng_faction_s 	= faction_owner//get_eng_faction(faction_owner)

/proc/add_faction_lenta_message(var/obj/item/device/stalker_pda/KPK_owner, var/sid_owner, var/name_owner, var/faction_owner, msg, selfsound = 0)
	for(var/obj/item/device/stalker_pda/KPK in KPKs)
		if(KPK_owner.eng_faction_s == KPK.eng_faction_s)
			var/factioncolor 	= get_faction_color(faction_owner)
			KPK.lentahtml = "<table style=\"margin-top: 0px; margin-bottom: 5px; border: 0px; background: #2e2e38;\">\
			<tr style=\"border: 0px solid black;\">\
			<td style=\"border: 0px solid black; vertical-align: top; background: #2e2e38;\" width=32 height=32>\
			<img id=\"ratingbox\" style=\"background: #2e2e38; border: 1px solid black;\" height=32 width=32 src=photo_[sid_owner]>\
			</td>\
			\
			<td width=386 height=32 align=\"top\" style=\"background: #131416; border: 0px; text-align:left; vertical-align: top;\">\
			\
			<p class=\"lentamsg\"><b><font color = \"[factioncolor]\">[name_owner]\[[faction_owner]\](faction chat)</font></b>:<br><font color = \"#afb2a1\">[msg]</font></p>\
			\
			</td>\
			\
			</tr>\
			</table>" + KPK.lentahtml
			show_lenta_message(KPK_owner, KPK, sid_owner, name_owner, faction_owner, msg, isfactionchat = 1)
	show_dead_lenta_message(KPK_owner, name_owner, faction_owner, msg, isfactionchat = 1)
	//var/eng_faction_s 	= faction_owner//get_eng_faction(faction_owner)

/proc/show_lenta_message(var/obj/item/device/stalker_pda/KPK_owner, var/obj/item/device/stalker_pda/KPK, var/sid_owner, var/name_owner, var/faction_owner, msg, selfsound = 0, var/isfactionchat = 0)

	var/mob/living/carbon/C = null

	if(KPK.loc && isliving(KPK.loc))
		C = KPK.loc
	if(C && C.stat != UNCONSCIOUS)

		var/factioncolor	= get_faction_color(faction_owner)
		//var/eng_faction_s 	= get_eng_faction(faction_owner)

		if(isfactionchat)
			C << russian_html2text("<p style=\"margin-top: 0px; margin-bottom: 0px;\">\icon[KPK]<b style=\"margin-top: 0px; margin-bottom: 0px;\"><font style=\"margin-top: 0px; margin-bottom: 0px;\" color=\"[factioncolor]\">[name_owner]\[[faction_owner]\](faction chat):</font></b><br><font color=\"#006699\"> \"[msg]\"</font></p>")
		else
			C << russian_html2text("<p style=\"margin-top: 0px; margin-bottom: 0px;\">\icon[KPK]<b style=\"margin-top: 0px; margin-bottom: 0px;\"><font style=\"margin-top: 0px; margin-bottom: 0px;\" color=\"[factioncolor]\">[name_owner]\[[faction_owner]\]:</font></b><br><font color=\"#006699\"> \"[msg]\"</font></p>")

		if(KPK_owner)
			if((KPK != KPK_owner || selfsound) && KPK.lenta_sound == 1)
				C << sound('sound/stalker/pda/sms.ogg', volume = 30)
		else
			if(KPK.lenta_sound)
				C << sound('sound/stalker/pda/sms.ogg', volume = 30)

/proc/show_dead_lenta_message(var/obj/item/device/stalker_pda/KPK_owner, var/name_owner, var/faction_owner, var/msg, var/isfactionchat = 0)
	var/factioncolor	= get_faction_color(faction_owner)
	if(isfactionchat)
		msg = "<p style=\"margin-top: 0px; margin-bottom: 0px;\">\icon[KPK_owner]<b style=\"margin-top: 0px; margin-bottom: 0px;\"><font style=\"margin-top: 0px; margin-bottom: 0px;\" color=\"[factioncolor]\">[name_owner]\[[faction_owner]\](faction chat):</font></b><br><font color=\"#006699\"> \"[msg]\"</font></p>"
	else
		msg = "<p style=\"margin-top: 0px; margin-bottom: 0px;\">\icon[KPK_owner]<b style=\"margin-top: 0px; margin-bottom: 0px;\"><font style=\"margin-top: 0px; margin-bottom: 0px;\" color=\"[factioncolor]\">[name_owner]\[[faction_owner]\]:</font></b><br><font color=\"#006699\"> \"[msg]\"</font></p>"

	for(var/mob/M in player_list)

		var/adminoverride = 0

		if(M.client && M.client.holder && (M.client.prefs.chat_toggles & CHAT_DEAD))
			adminoverride = 1

		if(istype(M, /mob/new_player) && !adminoverride)
			continue

		if(M.stat != DEAD && !adminoverride)
			continue

		if(istype(M, /mob/dead/observer))
			M << russian_html2text("<a href=?src=\ref[M];follow=\ref[src]>(F)</a> [msg]")
		else
			M << "[msg]"


/obj/item/device/stalker_pda/proc/refresh_rating(var/mob/living/carbon/human/H)
	var/count = 0
	ratinghtml = ""

	for(var/datum/data/record/R in sortRecordNum(data_core.stalkers, "rating", -1))
		if(R.fields["lastlogin"] + 12000 < world.time)
			continue

		var/obj/item/weapon/photo/P1 = R.fields["photo_front"]
		var/sid_p = R.fields["sid"]
		H << browse_rsc(P1.img, "photo_[sid_p]")
		var/n = R.fields["name"]
		var/r = R.fields["rating"]

		var/eng_f = R.fields["faction_s"]
		var/f = get_rus_faction(eng_f)

		var/rep_color = get_rep_color(R.fields["reputation"])
		var/rep = get_rep_name(R.fields["reputation"])
		var/eng_rep = get_eng_rep_name(R.fields["reputation"])

		var/rank_name = get_rus_rank_name(r)
		var/eng_rank_name = get_eng_rank_name(r)

		count++

		if(usr.client.prefs.chat_toggles & CHAT_LANGUAGE)
			ratinghtml += "<table style=\"margin-top: 0px; margin-bottom: 5px;\">\
					<tr style=\"border: 1px solid black;\">\
					\
					<td width=64 height=64 align=\"top\">\
					<img id=\"ratingbox\" height=64 width=64 src=photo_[sid_p]>\
					</td>\
					\
					<td height=64 width=354 align=\"top\" style=\"text-align:left;vertical-align: top;\">\
					\
					<b>\[[count]\]</b> [n] ([eng_f])<br>\
					<b>Rating</b> [eng_rank_name] ([r])<br>\
					<b>Reputation:</b> <font color=\"[rep_color]\">[eng_rep]</font><br>\
					\
					</td>\
					\
					</tr>\
					</table>"
		else
			ratinghtml += "<table style=\"margin-top: 0px; margin-bottom: 5px;\">\
					<tr style=\"border: 1px solid black;\">\
					\
					<td width=64 height=64 align=\"top\">\
					<img id=\"ratingbox\" height=64 width=64 src=photo_[sid_p]>\
					</td>\
					\
					<td height=64 width=354 align=\"top\" style=\"text-align:left;vertical-align: top;\">\
					\
					<b>\[[count]\]</b> [n] ([f])<br>\
					<b>�������:</b> [rank_name] ([r])<br>\
					<b>���������:</b> <font color=\"[rep_color]\">[rep]</font><br>\
					\
					</td>\
					\
					</tr>\
					</table>"

	return ratinghtml

/obj/item/device/stalker_pda/proc/make_avatar(var/mob/living/carbon/human/H)
	var/datum/outfit/avatar = new /datum/outfit

	if(H.w_uniform)
		avatar.uniform 		= H.w_uniform.type
	if(H.wear_suit)
		avatar.suit 		= H.wear_suit.type
	if(H.back)
		avatar.back			= H.back.type
	if(H.belt)
		avatar.belt 		= H.belt.type
	if(H.gloves)
		avatar.gloves		= H.gloves.type
	if(H.shoes)
		avatar.shoes		= H.shoes.type
	if(H.head)
		avatar.head			= H.head.type
	if(H.wear_mask)
		avatar.mask			= H.wear_mask.type
	if(H.glasses)
		avatar.glasses		= H.glasses.type
	if(H.s_store)
		avatar.suit_store	= H.s_store.type
	if(H.r_hand && !istype(H.r_hand ,/obj/item/device/stalker_pda))
		avatar.r_hand		= H.r_hand.type
	if(H.l_hand && !istype(H.l_hand ,/obj/item/device/stalker_pda))
		avatar.l_hand		= H.l_hand.type

	if(avatar.uniform == null || avatar.shoes == null)
		H << "<span class='warning'>��� ����� ������ ������ � ������� ����� ���, ��� ������ ����������!</span>"
	else
		var/image = get_avatar(H, avatar)

		var/obj/item/weapon/photo/photo_owner_front = new()
		var/obj/item/weapon/photo/photo_owner_west = new()
		var/obj/item/weapon/photo/photo_owner_east = new()
		var/obj/item/weapon/photo/photo_owner_back = new()

		photo_owner_front.photocreate(null, icon(image, dir = SOUTH))
		photo_owner_west.photocreate(null, icon(image, dir = WEST))
		photo_owner_back.photocreate(null, icon(image, dir = NORTH))
		photo_owner_east.photocreate(null, icon(image, dir = EAST))

		for(var/datum/data/record/sk in data_core.stalkers)
			if(H.sid == sk.fields["sid"])
				sk.fields["photo_front"]	= photo_owner_front
				sk.fields["photo_west"]		= photo_owner_west
				sk.fields["photo_east"] 	= photo_owner_east
				sk.fields["photo_back"] 	= photo_owner_back
				return

/obj/item/device/stalker_pda/proc/get_avatar(var/mob/living/carbon/human/H, var/datum/outfit/avatar)
	var/datum/preferences/P = H.client.prefs
	return get_flat_human_icon(null, avatar, P)

/obj/item/device/stalker_pda/proc/set_owner_info(var/datum/data/record/sk)
	var/obj/item/weapon/photo/P1 = sk.fields["photo_front"]
	var/obj/item/weapon/photo/P2 = sk.fields["photo_west"]
	var/obj/item/weapon/photo/P3 = sk.fields["photo_east"]
	var/obj/item/weapon/photo/P4 = sk.fields["photo_back"]

	usr << browse_rsc(P1.img, "photo_front")
	usr << browse_rsc(P2.img, "photo_west")
	usr << browse_rsc(P3.img, "photo_east")
	usr << browse_rsc(P4.img, "photo_back")

	eng_faction_s		= sk.fields["faction_s"]
	rus_faction_s 		= get_rus_faction(eng_faction_s)

	rating			= sk.fields["rating"]
	money			= sk.fields["money"]
	reputation		= sk.fields["reputation"]

	rep_name_s 		= get_rep_name(sk.fields["reputation"])
	eng_rep_name_s 	= get_eng_rep_name(sk.fields["reputation"])
	rep_color_s 	= get_rep_color(sk.fields["reputation"])

	rus_rank_name_s 	= get_rus_rank_name(sk.fields["rating"])
	eng_rank_name_s	= get_eng_rank_name(sk.fields["rating"])

/proc/get_rus_rank_name(var/rating)
	var/rus_rank_name_s = "�������"
	switch(rating)
		if(ZONE_LEGEND to INFINITY)
			rus_rank_name_s = "������� ����"
		if(EXPERT to ZONE_LEGEND)
			rus_rank_name_s = "������"
		if(VETERAN to EXPERT)
			rus_rank_name_s = "�������"
		if(EXPERIENCED to VETERAN)
			rus_rank_name_s = "�������"
		if(ROOKIE to EXPERT)
			rus_rank_name_s = "�������"
	return rus_rank_name_s

/proc/get_eng_rank_name(var/rating)
	var/eng_rank_name_s = "Rookie"
	switch(rating)
		if(ZONE_LEGEND to INFINITY)
			eng_rank_name_s = "Legend"
		if(EXPERT to ZONE_LEGEND)
			eng_rank_name_s = "Expert"
		if(VETERAN to EXPERT)
			eng_rank_name_s = "Veteran"
		if(EXPERIENCED to VETERAN)
			eng_rank_name_s = "Experienced"
		if(ROOKIE to EXPERIENCED)
			eng_rank_name_s = "Rookie"
	return eng_rank_name_s

/proc/get_rus_faction(var/eng_faction_s)
	var/faction_s = "��������"
	switch(eng_faction_s)
		if("Bandits")
			faction_s = "�������"
		if("Mercenaries")
			faction_s = "�������"
		if("Duty")
			faction_s = "����"
		if("Traders")
			faction_s = "��������"
		if("Freedom")
			faction_s = "�������"
		if("Monolith")
			faction_s = "�������"
	return faction_s

/proc/get_faction_color(var/eng_faction_s)
	var/factioncolor = "#ff7733"
	switch(eng_faction_s)
		if("Bandits")
			factioncolor = "#8c8c8c"
		if("Loners")
			factioncolor = "#ff7733"
		if("Mercenaries")
			factioncolor = "#3399ff"
		if("Duty")
			factioncolor = "#ff4d4d"
		if("Freedom")
			factioncolor = "#6cba3f"
	return factioncolor

/proc/get_rep_name(var/rep)
	var/rep_name_s = "����������&#x44F;"

	switch(rep)
		if(AMAZING to INFINITY)
			rep_name_s = "���� �����"
		if(VERYGOOD to AMAZING)
			rep_name_s = "����� ������&#x44F;"
		if(GOOD to VERYGOOD)
			rep_name_s = "������&#x44F;"
		if(NEUTRAL to GOOD)
			rep_name_s = "����������&#x44F;"
		if(BAD to NEUTRAL)
			rep_name_s = "�����&#x44F;"
		if(VERYBAD to BAD)
			rep_name_s = "����� �����&#x44F;"
		if(DISGUSTING)
			rep_name_s = "�����"

	return rep_name_s

/proc/get_eng_rep_name(var/rep)
	var/eng_rep_name_s = "Neutral"

	switch(rep)
		if(AMAZING to INFINITY)
			eng_rep_name_s = "Jesus"
		if(VERYGOOD to AMAZING)
			eng_rep_name_s = "Very Good"
		if(GOOD to VERYGOOD)
			eng_rep_name_s = "Good"
		if(NEUTRAL to GOOD)
			eng_rep_name_s = "Neutral"
		if(BAD to NEUTRAL)
			eng_rep_name_s = "Bad"
		if(VERYBAD to BAD)
			eng_rep_name_s = "Very Bad"
		if(DISGUSTING)
			eng_rep_name_s = "Asshole"

	return eng_rep_name_s

/proc/get_rep_color(var/rep)
	var/rep_color_s = "#ffe100"
	switch(rep)
		if(AMAZING to INFINITY)
			rep_color_s = "#00abdb" //#00abdb
		if(VERYGOOD to AMAZING)
			rep_color_s = "#b6ff38" //#6ddb00
		if(GOOD to VERYGOOD)
			rep_color_s = "#daff21" //#b6db00
		if(NEUTRAL to GOOD)
			rep_color_s = "#ffe100" //#ffb200
		if(BAD to NEUTRAL)
			rep_color_s = "#ff6b3a" //#db5700
		if(VERYBAD to BAD)
			rep_color_s = "#db2b00" //#db2b00
		if(DISGUSTING)
			rep_color_s = "#7c0000"
	return rep_color_s