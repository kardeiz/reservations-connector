A Sinatra app enabling Room Wizard devices to connect with phpScheduleIt using the Room Wizard API.

**Warning**: This code is not safe for a multi-process server environment. If you are working in such an environment, you will want to modify `TargetSystem::Authentication.auth_user` to load/store credentials in some other way, otherwise you will wind up with a number of processes with bad credentials. (There is some ugly code here for sure, but I am also not a big fan of how phpScheduleIt handles webservice authentication.)
