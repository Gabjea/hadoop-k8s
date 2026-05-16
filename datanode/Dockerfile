FROM ghcr.io/gabjea/hadoop-base:latest

# Changed to the DataNode web UI port (9864)
HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

# Changed to the DataNode specific variables and paths
ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

# Changed to expose the data directory
VOLUME /hadoop/dfs/data

# 9864 = Web UI, 9866 = Data Transfer
EXPOSE 9864 9866

CMD ["/run.sh"]