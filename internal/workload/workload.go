package workload

import "github.com/osbuild/images/pkg/rpmmd"

type Workload interface {
	GetPackages() []string
	GetRepos() []rpmmd.RepoConfig_
	GetServices() []string
	GetDisabledServices() []string
}

type BaseWorkload struct {
	Repos []rpmmd.RepoConfig_
}

func (p BaseWorkload) GetPackages() []string {
	return []string{}
}

func (p BaseWorkload) GetRepos() []rpmmd.RepoConfig_ {
	return p.Repos
}

func (p BaseWorkload) GetServices() []string {
	return []string{}
}

func (p BaseWorkload) GetDisabledServices() []string {
	return []string{}
}
