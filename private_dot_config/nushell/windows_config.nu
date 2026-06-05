let base = "C:/Program Files/Microsoft Visual Studio"
module vsdev_completer { 
    def version_complete [] {
        if not ($base | path exists) { return [] }
        glob $"($base)/*" --no-file
        | each { |f| $f | path basename  }
    }
    def vs_licence_complete [context: string] {
        let version = ($context | split words | last)
        let full_path = $base | path join $version | str replace "\\" "/"
        glob $"($full_path)/*" --no-file
            | each { |f| $f | path basename  }
    }
    export def --env vsdev [
        version: string@version_complete = "2022"
        vs_licence: string@vs_licence_complete = "Enterprise"
        arch: string = "amd64"    
    ] {
        let bat = $"($base)/($version)/($vs_licence)/Common7/Tools/VsDevCmd.bat"

        if not ($bat | path exists) {
            error make { msg: $"找不到 VsDevCmd.bat，路徑: ($bat)" }
        }

        # 透過 cmd 執行 VsDevCmd.bat 後 dump 所有環境變數
        # 注意：nushell 裡必須用 ^cmd 並分開傳參數，不能用整串 shell string
        let raw = (^cmd /c $bat $"-arch=($arch)" "&&" "set" | complete)

        # 解析 KEY=VALUE
        let env_map = ($raw.stdout
            | lines
            | where { |line| ($line | str contains "=") }
            | each { |line|
                let idx = ($line | str index-of "=")
                let key = ($line | str substring 0..<$idx)
                let val = ($line | str substring ($idx + 1)..)
                {key: $key, value: $val}
            }
            | where { |kv| ($kv.key | str length) > 0 }
        )

        # 套用 PATH (Windows 的 Path 大小寫不定)
        let path_entries = ($env_map | where { |kv| ($kv.key | str upcase) == "PATH" })
        if ($path_entries | length) > 0 {
            let path_val = ($path_entries | first | get value)
            $env.PATH = ($path_val | split row ";" | where { |p| ($p | str length) > 0 })
        }

        # 套用 VS 工具鏈相關環境變數
        let vs_keys = ["VSINSTALLDIR", "VCToolsInstallDir", "VisualStudioVersion",
                       "VCINSTALLDIR", "WindowsSdkDir", "WindowsSDKVersion",
                       "INCLUDE", "LIB", "LIBPATH", "Platform", "VSCMD_ARG_TGT_ARCH",
                       "DevEnvDir", "NETFXSDKDir"]
        for kv in $env_map {
            if ($vs_keys | any { |k| $k == $kv.key }) {
                load-env {($kv.key): $kv.value}
            }
        }

        print $"Visual Studio ($version) DevShell \(arch=($arch)\) 已啟用"
    }
}
use vsdev_completer * 

