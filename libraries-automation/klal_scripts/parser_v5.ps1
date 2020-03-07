$input_file_extension = '.edn'
$output_file_extension = '.txt'
$work_dir = "$((Get-Location).Path)\"

$lib_pattern = '(\(library [\s\S]*?)(?=\((library |design ))'
$cell_pattern = '(\(cell [\s\S]*?)(?=(\(cell |\)[\s]*\Z))'
$view_pattern = '(\(view [\s\S]*?)(?=(\(view |\(viewMap|\)[\s]*\Z))'
$port_pattern = '(\(port [\s\S]*?)(?=(\(port |\)[\s]*\)[\s]*\Z))'
$pin_name_pattern = '(?<=\(port )(.*)'
$pin_num_pattern = '(?<=\(designator ")([^"]+)'
$cell_name_pattern = '(?<=\(cell )(.*)'

# for 1 full match
# [regex]$rx='pattern'
# $rx.Match($DN)

function Parse-File {
	Param([System.String]$FNAME)
	Write-Host -ForegroundColor Yellow -BackgroundColor DarkCyan "parsing file `'$work_dir$FNAME$input_file_extension`'..."
	
	$input_file_data = Get-Content -Path "$work_dir$FNAME$input_file_extension" -Raw	
	$out_file = "$work_dir$FNAME$output_file_extension"
	
	$lib_list = [regex]::matches($input_file_data, "$lib_pattern") #| %{$_.value}
	for ($i=0; $i -lt ($lib_list.count - 1); $i++) {
		
		$cell_list = [regex]::matches($lib_list[$i].value, "$cell_pattern")
		foreach ($cell_i in $cell_list) {
			Write-Host "cell:" ([regex]::matches($cell_i.value, "$cell_name_pattern"))
			Add-Content -Path "$out_file" -Value "COMPONENT : $([regex]::matches($cell_i.value, "$cell_name_pattern"))"

			$pin_hashTable = @{}		
			$view_list = [regex]::matches($cell_i.value, "$view_pattern")
			foreach ($view_i in $view_list) {
				$port_list = [regex]::matches($view_i.value, "$port_pattern")
				foreach ($port_i in $port_list) {
					$pin_name = ([regex]::matches($port_i.value, "$pin_name_pattern")).value
					$pin_num = ([regex]::matches($port_i.value, "$pin_num_pattern")).value
					
					$pin_hashTable.Add("$pin_num","$pin_name")
				}
			}
			
			foreach ($key in $pin_hashTable.GetEnumerator()) {
				# "`t$($key.Name) : $($key.Value)"
				#"$($key.Name) : $($key.Value)" | Out-File -FilePath "$out_file" -Append -Encoding UTF8
				Add-Content -Path "$out_file" -Value "`t$($key.Name) : $($key.Value)" -NoNewline
			}
			
			Add-Content -Path "$out_file" -Value "`r`n`r`n" # tabulation between components
			$pin_hashTable.clear()
		}
	}
}

function Find-Files {
	$input_file_list = Get-ChildItem "$work_dir" -File | Where-Object -Property Name -like "*$input_file_extension"
	$output_file_list = @()

	Write-Host "The following [$input_file_extension] files were found: "
	foreach ($f in $input_file_list) {
		Write-Host "`t`'$($f.ToString())`'"
	}
	
	foreach ($f in $input_file_list) {
		$ff = [System.IO.Path]::GetFileNameWithoutExtension("$f").ToString()
		if("$ff$output_file_extension" -notin (Get-ChildItem "$work_dir" -File -Name)) {
			$output_file_list += "$ff"
		}
	}
	
	if (($output_file_list).Count -gt 0){
		Write-Host "The following [$output_file_extension] files should be created: "
		foreach ($f in $output_file_list) {
			Write-Host "`t`'$f$output_file_extension`'"
		}
	} else {
		Write-Host "Nothing to process"
	}
	
	return $output_file_list
}

function Start-Processing {
	Write-Host -ForegroundColor Gray -BackgroundColor DarkGreen "start of rocessing"
	$files_to_process = Find-Files
	
	foreach ($line in $files_to_process) {
		Write-Host -ForegroundColor Yellow -BackgroundColor DarkCyan "creating file `'$line$output_file_extension`'..."
		New-Item -Path "$work_dir$line$output_file_extension" -ItemType File
		Parse-File -FNAME "$line"
	}
	
	Write-Host -ForegroundColor Gray -BackgroundColor DarkGreen "`r`nend of processing"
}


# start of execution
clear
Write-Host "working directory : `'$work_dir`'`r`n"
Start-Processing