// This file is part of BOINC.
// http://boinc.berkeley.edu
// Copyright (C) 2018 University of California
//
// BOINC is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// BOINC is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with BOINC.  If not, see <http://www.gnu.org/licenses/>.

#ifndef BOINC_ANDROID_CONFIG_H
#define BOINC_ANDROID_CONFIG_H

#include "config.h"

#ifndef ANDROID_64

#undef _FILE_OFFSET_BITS
#undef _LARGE_FILES
#undef _LARGEFILE_SOURCE
#undef _LARGEFILE64_SOURCE

#if HAVE_SYS_STATFS_H

#if HAVE_SYS_STATVFS_H
#undef HAVE_SYS_STATVFS_H
#define HAVE_SYS_STATVFS_H 0
#endif

#else
#error Need to specify a method to obtain free/total disk space
#endif

#endif

#endif // double-inclusion protection