#!/bin/bash
# LinuxGSM command_backup.sh module
# Author: Daniel Gibbs
# Contributors: http://linuxgsm.com/contrib
# Website: https://linuxgsm.com
# Description: Wipes server data, useful after updates for some games like Rust.

commandname="WIPE"
commandaction="Wiping"
functionselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"
fn_firstcommand_set

# Provides an exit code upon error.
fn_wipe_exit_code(){
	((exitcode=$?))
	if [ "${exitcode}" != 0 ]; then
		fn_script_log_fatal "${currentaction}"
		core_exit.sh
	else
		fn_print_ok_eol_nl
	fi
}

# Removes files to wipe server.
fn_wipe_server_files(){
	fn_print_start_nl "Wiping server"
	fn_script_log_info "Wiping server"

	fn_print_start_nl "Changing the server seed"
	fn_script_log_info "Changing the server seed"

	fn_fetch_file_github "lgsm/functions" "seed_changer.py" "${functionsdir}" "chmodx" "norun" "noforce" "nohash"

	python3 "${functionsdir}"/seed_changer.py "${servercfgfullpath}" "${serverseedsfullpath}"

	fn_print_start_nl "Changed the server's seed"
	fn_script_log_info "Changed the server's seed"

	# Wipe procedural map.
	if [ -n "$(find "${serveridentitydir}" -type f -name "proceduralmap.*.map")" ]; then
		echo -en "removing procedural map proceduralmap.*.map file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing procedural map file(s): ${serveridentitydir}/proceduralmap.*.map"
		find "${serveridentitydir:?}" -type f -name "proceduralmap.*.map" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no procedural map file to remove"
		fn_sleep_time
		fn_script_log_pass "No procedural map file to remove"
	fi
	# Wipe Barren map.
	if [ -n "$(find "${serveridentitydir}" -type f -name "barren*.map")" ]; then
		echo -en "removing barren map barren*.map file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing map file(s): ${serveridentitydir}/barren*.map"
		find "${serveridentitydir:?}" -type f -name "barren*.map" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no barren map file to remove"
		fn_sleep_time
		fn_script_log_pass "No barren map file to remove"
	fi
	# Wipe custom map.
	if [ -n "$(find "${serveridentitydir}" -type f -name "*.map")" ]; then
		echo -en "removing custom map file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing map file(s): ${serveridentitydir}/*.map"
		find "${serveridentitydir:?}" -type f -name "*.map" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no map file to remove"
		fn_sleep_time
		fn_script_log_pass "No map file to remove"
	fi
	# Wipe custom map save.
	if [ -n "$(find "${serveridentitydir}" -type f -name "*.sav*")" ]; then
		echo -en "removing map save *.sav* file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing map save(s): ${serveridentitydir}/*.sav*"
		find "${serveridentitydir:?}" -type f -name "*.sav*" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no map save to remove"
		fn_sleep_time
		fn_script_log_pass "No map save to remove."
	fi
	# Wipe user dir, might be a legacy thing, maybe to be removed.
	if [ -d "${serveridentitydir}/user" ]; then
		echo -en "removing user directory..."
		fn_sleep_time
		fn_script_log_info "removing user directory: ${serveridentitydir}/user"
		rm -rf "${serveridentitydir:?}/user"
		fn_wipe_exit_code
		fn_sleep_time
		# We do not print additional information if there is nothing to remove since this might be obsolete.
	fi
	# Wipe storage dir, might be a legacy thing, maybe to be removed.
	if [ -d "${serveridentitydir}/storage" ]; then
		echo -en "removing storage directory..."
		fn_sleep_time
		fn_script_log_info "removing storage directory: ${serveridentitydir}/storage"
		rm -rf "${serveridentitydir:?}/storage"
		fn_wipe_exit_code
		fn_sleep_time
		# We do not print additional information if there is nothing to remove since this might be obsolete.
	fi
	# Wipe sv.files.
	if [ -n "$(find "${serveridentitydir}" -type f -name "sv.files.*.db")" ]; then
		echo -en "removing server misc srv.files*.db file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing server misc files: ${serveridentitydir}/sv.files.*.db"
		find "${serveridentitydir:?}" -type f -name "sv.files.*.db" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
		# No further information if not found because it should I could not get this file showing up.
	fi
	# Wipe player death files.
	if [ -n "$(find "${serveridentitydir}" -type f -name "player.deaths.*.db")" ]; then
		echo -en "removing player deaths player.deaths.*.db file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing player death files: ${serveridentitydir}/player.deaths.*.db"
		find "${serveridentitydir:?}" -type f -name "player.deaths.*.db" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no player death to remove"
		fn_sleep_time
		fn_script_log_pass "No player death to remove"
	fi
	# Wipe player states files
	if [ -n "$(find "${serveridentitydir}" -type f -name "player.states.*.db")" ]; then
		echo -en "removing player states player.states.*.db file(s)..."
		fn_sleep_time
		fn_script_log_info "Removing player states: ${serveridentitydir}/player.states.*.db"
		find "${serveridentitydir:?}" -type f -name "player.states.*.db" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no player states to remove"
		fn_sleep_time
		fn_script_log_pass "No player states to remove"
	fi


	####################################################
	# Oxide custom data removal


	# Wipe furnace splitter files
	# data/FurnaceSplitter.json
	if [ -n "$(find "${oxidedata}" -type f -name "FurnaceSplitter.json")" ]; then
		echo -en "Removing FurnaceSplitter data file..."
		fn_sleep_time
		fn_script_log_info "Removing FurnaceSplitter data file: ${oxidedata}/FurnaceSplitter.json"
		find "${oxidedata:?}" -type f -name "FurnaceSplitter.json" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no FurnaceSplitter.json to remove"
		fn_sleep_time
		fn_script_log_pass "No FurnaceSplitter.json to remove"
	fi


	# Wipe auto lock files
	# data/AutoLock.json
	if [ -n "$(find "${oxidedata}" -type f -name "AutoLock.json")" ]; then
		echo -en "Removing AutoLock data file..."
		fn_sleep_time
		fn_script_log_info "Removing AutoLock data file: ${oxidedata}/AutoLock.json"
		find "${oxidedata:?}" -type f -name "AutoLock.json" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no AutoLock.json to remove"
		fn_sleep_time
		fn_script_log_pass "No AutoLock.json to remove"
	fi


	# Wipe NTeleportation files
	# data/NTeleportationAdmin.json
	# data/NTeleportationBandit.json
	# data/NTeleportationHome.json
	# data/NTeleportationIsland.json
	# data/NTeleportationOutpost.json
	# data/NTeleportationTPR.json
	# data/NTeleportationTPT.json
	if [ -n "$(find "${oxidedata}" -type f -name "NTeleportation*.json")" ]; then
		echo -en "removing NTeleportation*.json files..."
		fn_sleep_time
		fn_script_log_info "Removing NTeleportation files: ${oxidedata}/NTeleportation*.json"
		find "${oxidedata:?}" -type f -name "NTeleportation*.json" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no NTeleportation files to remove"
		fn_sleep_time
		fn_script_log_pass "no NTeleportation files to remove"
	fi


	# Wipe shop tokens data (Only on full wipes)
	# data/ServerRewards/player_data.json"
	if [ "${fullwipe}" == "1" ]; then
		if [ -n "$(find "${serverrewardsdata}" -type f -name "player_data.json")" ]; then
			echo -en "Removing Server Rewards player_data.json files..."
			fn_sleep_time
			fn_script_log_info "Removing Server Rewards player_data files: ${serverrewardsdata}/player_data.json"
			find "${serverrewardsdata:?}" -type f -name "player_data.json" -delete | tee -a "${lgsmlog}"
			fn_wipe_exit_code
			fn_sleep_time
		else
			echo -e "no Server Rewards player_data files to remove"
			fn_sleep_time
			fn_script_log_pass "no Server Rewards player_data files to remove"
		fi
	fi


	####################################################


	# Wipe blueprints only if full-wipe command was used.
	if [ "${fullwipe}" == "1" ]; then
		if [ -n "$(find "${serveridentitydir}" -type f -name "player.blueprints.*.db")" ]; then
			echo -en "removing blueprints player.blueprints.*.db file(s)..."
			fn_sleep_time
			fn_script_log_info "Removing blueprint file(s): ${serveridentitydir}/player.blueprints.*.db"
			find "${serveridentitydir:?}" -type f -name "player.blueprints.*.db" -delete | tee -a "${lgsmlog}"
			fn_wipe_exit_code
			fn_sleep_time
		else
			echo -e "no blueprint file to remove"
			fn_sleep_time
			fn_script_log_pass "No blueprint file to remove"
		fi
	elif [ -n "$(find "${serveridentitydir}" -type f -name "player.blueprints.*.db")" ]; then
		echo -e "keeping blueprints"
		fn_sleep_time
		fn_script_log_info "Keeping blueprints"
	else
		echo -e "no blueprints found"
		fn_sleep_time
		fn_script_log_pass "No blueprints found"
	fi
	# Wipe some logs that might be there.
	if [ -n "$(find "${serveridentitydir}" -type f -name "Log.*.txt")" ]; then
		echo -en "removing log files..."
		fn_sleep_time
		fn_script_log_info "Removing log files: ${serveridentitydir}/Log.*.txt"
		find "${serveridentitydir:?}" -type f -name "Log.*.txt" -delete
		fn_wipe_exit_code
		fn_sleep_time
		# We do not print additional information if there are no logs to remove.
	fi
}

fn_stop_warning(){
	fn_print_warn "this game server will be stopped during wipe"
	fn_script_log_warn "this game server will be stopped during wipe"
	totalseconds=3
	for seconds in {3..1}; do
		fn_print_warn "this game server will be stopped during wipe: ${totalseconds}"
		totalseconds=$((totalseconds - 1))
		sleep 1
		if [ "${seconds}" == "0" ]; then
			break
		fi
	done
	fn_print_warn_nl "this game server will be stopped during wipe"
}

fn_wipe_warning(){
	fn_print_warn "wipe is about to start"
	fn_script_log_warn "wipe is about to start"
	totalseconds=3
	for seconds in {3..1}; do
		fn_print_warn "wipe is about to start: ${totalseconds}"
		totalseconds=$((totalseconds - 1))
		sleep 1
		if [ "${seconds}" == "0" ]; then
			break
		fi
	done
	fn_print_warn "wipe is about to start"
}

# Will change the seed everytime the wipe command is run if the seed in config is not set.
fn_wipe_random_seed(){
	shuf -i 1-2147483647 -n 1 > "${datadir}/${selfname}-seed.txt"
}

fn_print_dots ""
check.sh

# Check if there is something to wipe.
if [ -d "${serveridentitydir}/storage" ]||[ -d "${serveridentitydir}/user" ]||[ -n "$(find "${serveridentitydir}" -type f -name "*.sav*")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "Log.*.txt")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "player.deaths.*.db")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "player.blueprints.*.db")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "sv.files.*.db")" ]; then
	fn_wipe_warning
	check_status.sh
	if [ "${status}" != "0" ]; then
		fn_stop_warning
		exitbypass=1
		command_stop.sh
		fn_firstcommand_reset
		fn_wipe_server_files
		exitbypass=1
		command_start.sh
		fn_firstcommand_reset
	else
		fn_wipe_server_files
	fi
	fn_print_complete_nl "Wiping ${selfname}"
	fn_script_log_pass "Wiping ${selfname}"
	fn_wipe_random_seed
else
	fn_print_ok_nl "Wipe not required"
	fn_script_log_pass "Wipe not required"
fi
core_exit.sh
