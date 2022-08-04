#!/usr/bin/env python3

import json


def main():
    for majmin in ("4.10", "4.9", "4.8"):
        with open(f"{majmin}.json") as f:
            versions = json.loads(f.read())

        print(f"OCP version {majmin}:")
        kernel_change_count = 0
        rhcos_change_count = 0
        for v1, v2 in zip(versions[:-1], versions[1:]):
            rhcos_changed = v1["rhcos_ver"] != v2["rhcos_ver"]
            kernel_changed = v1["kernel_ver"] != v2["kernel_ver"]

            print(f"\t{v1['ocp_version']} -> {v2['ocp_version']}:")
            if rhcos_changed:
                rhcos_change_count += 1
                print(f"\t\tRHCOS changed: {v1['rhcos_ver']} -> {v2['rhcos_ver']}")
            if kernel_changed:
                kernel_change_count += 1
                print(f"\t\tKernel changed: {v1['kernel_ver']} -> {v2['kernel_ver']}")
        print(
            f"Kernel changes: {kernel_change_count} (changed {kernel_change_count} out of {len(versions) - 1} ({kernel_change_count / (len(versions) - 1) * 100:.2f}%))"
        )
        print(
            f"RHCOS changes: {rhcos_change_count} (changed {rhcos_change_count} out of {len(versions) - 1} ({rhcos_change_count / (len(versions) - 1) * 100:.2f}%))"
        )
        print()


if __name__ == "__main__":
    main()
