{
  config,
  pkgs,
  lib,
  ...
}: let
  ryzenadj-service =
    pkgs.writers.writePython3Bin "ryzenadj-service" {
      libraries = [pkgs.ryzenadj];
      flakeIgnore = ["E501" "F405" "F403" "E265"];
    } ''
      #!/bin/env python3

      import argparse
      import os
      import sys
      import time
      from ctypes import *

      lib_path = os.path.dirname(os.path.abspath(__file__))
      os.chdir(lib_path)

      lib = cdll.LoadLibrary("${pkgs.ryzenadj}/lib/libryzenadj.so")

      # define ctype mappings for types which can not be mapped automatically
      # ryzenadj tables
      lib.init_ryzenadj.restype = c_void_p
      lib.refresh_table.argtypes = [c_void_p]
      # Stapm value and limit
      lib.get_stapm_limit.restype = c_float
      lib.get_stapm_limit.argtypes = [c_void_p]
      # Slow limit and value
      lib.get_slow_limit.restype = c_float
      lib.get_slow_limit.argtypes = [c_void_p]
      # Fast limit and value
      lib.get_fast_limit.restype = c_float
      lib.get_fast_limit.argtypes = [c_void_p]
      # Slow time and value
      lib.get_slow_time.restype = c_float
      lib.get_slow_time.argtypes = [c_void_p]
      # stapm time and value
      lib.get_stapm_time.restype = c_float
      lib.get_stapm_time.argtypes = [c_void_p]
      # Vrm Max Current and value
      lib.get_vrmmax_current.restype = c_float
      lib.get_vrmmax_current.argtypes = [c_void_p]
      # Tctl cpu temp
      lib.get_tctl_temp.restype = c_float
      lib.get_tctl_temp.argtypes = [c_void_p]

      ry = lib.init_ryzenadj()

      if not ry:
          sys.exit("RyzenAdj could not get initialized")

      error_messages = {
          -1: "{:s} is not supported on this family\n",
          -3: "{:s} is not supported on this SMU\n",
          -4: "{:s} is rejected by SMU\n",
      }


      def adjust(field, value):
          function_name = "set_" + field
          adjust_func = lib.__getattr__(function_name)
          adjust_func.argtypes = [c_void_p, c_ulong]
          res = adjust_func(ry, value)
          if res:
              error = error_messages.get(res, "{:s} did fail with {:d}\n")
              sys.stderr.write(error.format(function_name, res))
          else:
              print(f"Succesfully set {field} to {value}")


      def enable(field):
          function_name = "set_" + field
          adjust_func = lib.__getattr__(function_name)
          adjust_func.argtypes = [c_void_p]
          res = adjust_func(ry)
          if res:
              error = error_messages.get(res, "{:s} did fail with {:d}\n")
              sys.stderr.write(error.format(function_name, res))
          else:
              print(f"Sucessfully enable {field}")


      def set(args):
          adjust("stapm_limit", args.stapm_limit)
          adjust("fast_limit", args.fast_limit)
          adjust("slow_limit", args.slow_limit)
          # adjust("slow_time", args.slow_time)
          # adjust("stapm_time", args.stapm_time)
          adjust("tctl_temp", args.tctl_temp)
          adjust("vrmmax_current", args.vrmmax_current)
          enable("max_performance")


      def loop(args):
          set(args)
          while True:
              lib.refresh_table(ry)
              current = round(lib.get_tctl_temp(ry))
              if current != 85:
                  set(args)
              time.sleep(3)


      def parse_args():
          parser = argparse.ArgumentParser(
              prog="Ryzenadj Service",
              description="Simple Ryzenadj python service to keep values set",
          )
          parser.add_argument("--stapm-limit", action="store", required=True, type=int)
          parser.add_argument("--fast-limit", action="store", required=True, type=int)
          parser.add_argument("--slow-limit", action="store", required=True, type=int)
          # parser.add_argument("--slow-time", action="store", required=True, type=int)
          # parser.add_argument("--stapm-time", action="store", required=True, type=int)
          parser.add_argument("--tctl-temp", action="store", required=True, type=int)
          parser.add_argument("--vrmmax-current", action="store", required=True, type=int)
          return parser.parse_args()


      def main():
          args = parse_args()
          loop(args)


      if __name__ == "__main__":
          main()
    '';
in {
  options = {
    crony.ryzenadj.enable = lib.mkEnableOption "Enable ryzenadj and customize it for my system.";
  };

  config = lib.mkIf config.crony.ryzenadj.enable {
    # Add ryzen-smu driver to allow reading values
    boot.extraModulePackages = with config.boot.kernelPackages; [ryzen-smu];

    # Install ryzenadj globally
    environment.systemPackages = with pkgs; [
      ryzenadj
    ];

    # Setup python service for ryzenadj
    systemd.services.ryzenadj = {
      enable = true;
      description = "Set my cpu power usage power to something more manageable.";
      wantedBy = ["multi-user.target"];
      script = "${ryzenadj-service}/bin/ryzenadj-service --stapm-limit 35000 --fast-limit 35000 --slow-limit 35000 --tctl-temp 90 --vrmmax-current 51000";
    };
  };
}
