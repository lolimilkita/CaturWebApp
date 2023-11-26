USE [task_manager]

CREATE TABLE [dbo].[status_tasks](
	[id] [int] NOT NULL,
	[status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tasks]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tasks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](255) NULL,
	[description] [text] NULL,
	[status] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
 CONSTRAINT [PK__tasks__3213E83FA45146DA] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tasks] ADD  CONSTRAINT [DF__tasks__status__3A81B327]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[tasks]  WITH CHECK ADD  CONSTRAINT [fk_status_tasks] FOREIGN KEY([status])
REFERENCES [dbo].[status_tasks] ([id])
GO
ALTER TABLE [dbo].[tasks] CHECK CONSTRAINT [fk_status_tasks]
GO
/****** Object:  StoredProcedure [dbo].[usp_DelTask]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DelTask]
	@ID		int
AS
BEGIN
	DELETE	FROM [dbo].[tasks]
	WHERE	ID = @ID
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetStatus]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetStatus]
AS
BEGIN
	SELECT	id, status
	FROM	dbo.status_tasks order by id
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTask]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetTask]
	@ID		int
AS
BEGIN
	SELECT	[id]
			,[title]
			,[description]
			,[status]
			,[created_at]
			,[updated_at]
	FROM	[dbo].[tasks]
	WHERE	id = @ID
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTasks]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetTasks]
	@Srch	varchar(250) = null,
	@fltr	varchar(250) = null,
	@sql varchar(max) = null,
	@sqlWhere varchar(max) = null
AS
BEGIN
	IF(@fltr is null)
		set @sqlWhere = 'WHERE title like ''%'+@Srch+'%'' or description like ''%'+@Srch+'%'''
	IF(@Srch is null)
		set @sqlWhere = 'WHERE a.status = '+@fltr+''
	IF(@fltr is null and @Srch is null)
		set @sqlWhere = ''

	set @sql = N'
		SELECT	a.[id]
      ,a.[title]
      ,a.[description]
      ,b.status
      ,a.[created_at]
      ,a.[updated_at]
	  FROM [task_manager].[dbo].[tasks] as a join status_tasks as b on b.id = a.status
	  '+@sqlWhere+'
	'
	exec(@sql)
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_InsTask]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_InsTask]
	@Title				varchar(250),
	@Description		varchar(max),
	@StatusID			varchar(5) = null
AS
BEGIN

	IF(@StatusID is null)
		Set @StatusID = 1

	INSERT INTO [dbo].[tasks]
				([title]
				,[description]
				,[status]
				,[created_at])
		 VALUES
				(@Title
				,@Description
				,@StatusID
				,GETDATE())
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdTask]    Script Date: 11/26/2023 7:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdTask]
	@ID				int			= null,
	@Title			varchar(250)	= null,
	@Description	varchar(MAX) = null,
	@StatusID		int = null
AS
BEGIN
	UPDATE	[dbo].[tasks]
	SET		title			= ISNULL(@Title, title)
			,description	= ISNULL(@Description, description)
			,status			= ISNULL(@StatusID, status)
			,updated_at     = GETDATE()
	WHERE	ID = @ID
END;
GO
USE [master]
GO
ALTER DATABASE [task_manager] SET  READ_WRITE 
GO
