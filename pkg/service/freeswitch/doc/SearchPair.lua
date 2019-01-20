-- https://www.bionicspirit.com/blog/2009/02/20/tips-for-creating-voip-dialer.html

freeswitch.consoleLog("info", "-= SearchPair.lua =-\n");

if ( session:ready() ) then
    -- get arguments param
    aDstNum = argv[1];
    RetVal  = argv[2];

    if ( string.len(aDstNum) == 12 and string.sub(aDstNum, 0, 2) == "38") then
      DstNumShort = string.sub(aDstNum, 3);
    else
      DstNumShort = aDstNum;
    end

    dbPath = "sqlite://" .. session:getVariable("db_dir") .. "/cdr.db";
    dbh = freeswitch.Dbh(dbPath);
    assert(dbh:connected());

    -- get last record called from aDstNum
    SQL = "SELECT caller_id_name " ..
           "FROM cdr " ..
           "WHERE (destination_number like '%" .. aDstNum .. "') OR (destination_number like '%" .. DstNumShort .. "') " ..
           "ORDER BY end_stamp DESC " ..
           "LIMIT 1 ";

    dbh:query(SQL, 
	function(qrow)
	    RetVal = qrow.caller_id_name;
	end
    );

    freeswitch.consoleLog("info", " 2======== " .. SQL .. ", " .. RetVal .. " =====\n");
    dbh:release();

    --session:answer();
    --session:execute("bridge", "user/2010");
    --session:hangup();

    --returning result
    --session:setVariable("ResNum", aDstNum + 1);
    --session:execute("set", "ret_var=w123");
    stream:write(RetVal); 
end
