import yaml

# ############ SETUP ##############################
configfile: "configs/config_master.yaml"
# configfile: "configs/config.json"
workdir: config['workdir']

# include helper functions
include: "includes/io.snk"
include: "includes/filter_utils.snk"
include: "includes/filter.snk"

# load the global files
filter_file = config['filter2_file']
print(f"Loading {filter_file}")

mut_dfs = read_filter2(filter_file)
# retrieve the file_df with all the file paths from the samplesheet
sample_dfs = {}
for f in ['filter2', 'dropped']:
    sample_dfs[f] = get_sample_df(mut_dfs[f], input_dir=config['inputdir'], all_projects=config['projects'])

# print(sample_dfs['filter2'])

# print(get_TN_sample_list(sample_dfs['filter2']))
# specified wildcards have to match the regex
wildcard_constraints:
    # eg sample cannot contain _ or / to prevent ambiguous wildcards
    sample = "[^_/.B]+",
    filta = "dropped|filter2",

# ############## MASTER RULE ##############################################

rule all:
    input:
        expand("filterbam/{sample}.filter2.bam", sample=get_TN_sample_list(sample_dfs['filter2'])),
        expand("filterbam/{sample}.dropped.bam", sample=get_TN_sample_list(sample_dfs['dropped'])),


###########################################################################

# print out of installed tools
onstart:
    print("    FILTERBAM PIPELINE STARTING.......")

onsuccess:
    # shell("export PATH=$ORG_PATH; unset ORG_PATH")
    print("Workflow finished - everything ran smoothly")

    # cleanup
    if config['cleanup']:
        pass
