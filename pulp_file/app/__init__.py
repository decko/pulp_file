from pulpcore.plugin import PulpPluginAppConfig


class PulpFilePluginAppConfig(PulpPluginAppConfig):
    """
    Entry point for pulp_file plugin.
    """

    name = "pulp_file.app"
    label = "file"
    version = "1.16.0.dev"
    python_package_name = "pulp-file"
    domain_compatible = True
