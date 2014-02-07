USE [SportsSite]
GO
/****** Object:  StoredProcedure [dbo].[AddEvent]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[AddEvent]
(@Id int output,
@Name varchar
           ,@Description varchar(500)
           ,@HostId int
           ,@TypeId int
           ,@StartTime datetime
           ,@EndTime datetime
           ,@HomeTeamId int
           ,@VisitorTeamId int
           ,@CreatedBy int)
           
AS 
Begin      

INSERT INTO [Event]

           ([Name]
           ,[Description]
           ,[HostId]
           ,[TypeId]
           ,[StartTime]
           ,[EndTime]
           ,[HomeTeamId]
           ,[VisitorTeamId]
           ,[CreatedBy]
           ,[CreatedOn]
           )
     VALUES
     (@Name,
     @Description 
           ,@HostId 
           ,@TypeId 
           ,@StartTime 
           ,@EndTime 
           ,@HomeTeamId 
           ,@VisitorTeamId 
           ,@CreatedBy
           , GETDATE())
          
   SET  @Id=SCOPE_IDENTITY()
END

GO
/****** Object:  StoredProcedure [dbo].[AddEventMedia]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[AddEventMedia]
           (@Id int output
            ,@EventId int
           ,@MediaName varchar(255)
           ,@MediaTypeId int
           ,@CreatedBy int
           ,@ModifiedBy int=null
           ,@ModifiedOn DateTime=null)
As
Begin
INSERT INTO [EventMedia]
           ([EventId]
           ,[MediaName]
           ,[MediaTypeId]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[ModifiedBy]
           ,[ModifiedOn])
           
 Values    ( @EventId      
           ,@MediaName
           ,@MediaTypeId
           ,@CreatedBy
            ,GETDATE()
           ,@ModifiedBy
           ,@ModifiedOn)
           SET @Id=SCOPE_IDENTITY()
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteEvent]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DeleteEvent]
@Id int

AS
Begin
      Delete From Event
          Where Id=@Id
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteEventMedia]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DeleteEventMedia]
@Id int

AS
Begin
      Delete From EventMedia
          Where Id=@Id
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteMediaComments]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DeleteMediaComments]
@Id int

AS
Begin
DELETE Child  from mediacomment m Join EventMedia Em
on m.MediaId=Em.Id

      Delete From MediaComment
          Where Id=@Id
END

GO
/****** Object:  StoredProcedure [dbo].[SaveEvent]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SaveEvent]
            @Id int output
           ,@Name varchar(100)
           ,@Description varchar(500)
           ,@HostId int
           ,@TypeId int
           ,@StartTime datetime
           ,@EndTime datetime
           ,@HomeTeamId int
           ,@VisitorTeamId int=Null
           ,@CreatedBy int
           ,@ModifiedBy int=Null
           ,@ModifiedOn datetime=Null
AS
 Begin
     If EXISTS (Select 1 row from Event where Id=@Id)
Begin

UPDATE [Event]
           SET Name=@Name
           ,Description=@Description
           ,HostId=@HostId
           ,TypeId=@TypeId
           ,StartTime=@StartTime
           ,EndTime=@EndTime
           ,HomeTeamId=@HomeTeamId
           ,VisitorTeamId=@VisitorTeamId
           ,CreatedBy=@CreatedBy
           ,CreatedOn=GETDATE()
           ,[ModifiedBy]=@ModifiedBy
           ,[ModifiedOn]=@ModifiedOn
           where Id=@Id
          
   End
    Else 
        Begin
    Declare @NewId Int
 Insert into Event(Name,Description,HostId,TypeId,StartTime,EndTime,HomeTeamId,VisitorTeamId,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
 Values(@Name,@Description,@HostId,@TypeId,@StartTime,@EndTime,@HomeTeamId,@VisitorTeamId,@CreatedBy,GETDATE(),@ModifiedBy,@ModifiedOn)
 SET @NewId=SCOPE_IDENTITY()
 END
 END

GO
/****** Object:  StoredProcedure [dbo].[SaveMediaComments]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SaveMediaComments]
           (@Id int output
           ,@MediaId int
           ,@Comments nvarchar(500)
           ,@CreatedBy int
           ,@ModifiedBy int=Null
           ,@ModifiedOn datetime=Null)
 AS
 Begin
 If Exists (Select 1 Row From MediaComment where Id=@Id)
 Begin
 UPDATE MediaComment
 SET
            MediaId=@MediaId,
            Comments=@Comments,
            CreatedOn=GETDATE(),
            CreatedBy=@CreatedBy,
            ModifiedBy=@ModifiedBy,
            ModifiedOn=@ModifiedOn
            where Id=@Id
    END        

ELSE
BEGIN
      DECLARE @NewId int

      
            INSERT INTO [MediaComment]
           (
           [MediaId]
           ,[Comments]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[ModifiedBy]
           ,[ModifiedOn])
     VALUES
           (
           @MediaId,
           @Comments, 
           @CreatedBy,
           GETDATE(),
          @ModifiedBy,
           @ModifiedOn)
          SET @NewId=SCOPE_IDENTITY()
          
END



END

GO
/****** Object:  StoredProcedure [dbo].[UpdateEvent]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[UpdateEvent]
            @Id int output
           ,@Name varchar(100)
           ,@Description varchar(500)
           ,@HostId int
           ,@TypeId int
           ,@StartTime datetime
           ,@EndTime datetime
           ,@HomeTeamId int
           ,@VisitorTeamId int=Null
           ,@CreatedBy int
           ,@ModifiedBy int=Null
           ,@ModifiedOn datetime=Null
AS
 Begin
     If EXISTS (Select 1 row from Event where Id=@Id)
Begin

UPDATE [Event]
           SET Name=@Name
           ,Description=@Description
           ,HostId=@HostId
           ,TypeId=@TypeId
           ,StartTime=@StartTime
           ,EndTime=@EndTime
           ,HomeTeamId=@HomeTeamId
           ,VisitorTeamId=@VisitorTeamId
           ,CreatedBy=@CreatedBy
           ,CreatedOn=GETDATE()
           ,[ModifiedBy]=@ModifiedBy
           ,[ModifiedOn]=@ModifiedOn
           where Id=@Id
          
   End
    
 END

GO
/****** Object:  StoredProcedure [dbo].[UpdateMediaComments]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[UpdateMediaComments]
           (@Id int output
           ,@MediaId int
           ,@Comments nvarchar(500)
           ,@CreatedBy int
           ,@ModifiedBy int=Null
           ,@ModifiedOn datetime=Null)
 AS
 Begin
 If Exists (Select 1 Row From MediaComment where Id=@Id)
 Begin
 UPDATE MediaComment
 SET
            MediaId=@MediaId,
            Comments=@Comments,
            CreatedOn=GETDATE(),
            CreatedBy=@CreatedBy,
            ModifiedBy=@ModifiedBy,
            ModifiedOn=@ModifiedOn
            where Id=@Id
    END        


END

GO
/****** Object:  Table [dbo].[CityStateZip]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CityStateZip](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](20) NULL,
	[Zipcode] [int] NOT NULL,
 CONSTRAINT [PK_EviteStateCity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Event]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Event](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](500) NULL,
	[HostId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[HomeTeamId] [int] NULL,
	[VisitorTeamId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventAddress]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[Street1] [varchar](50) NOT NULL,
	[Street2] [varchar](50) NULL,
	[CityId] [int] NOT NULL,
 CONSTRAINT [PK_EventAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventComment]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventComments] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[EventId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_EventComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EventMedia]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventMedia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NULL,
	[MediaName] [varchar](255) NOT NULL,
	[MediaTypeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_EventMedia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventType]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MediaComment]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MediaComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MediaId] [int] NOT NULL,
	[Comments] [nvarchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_MediaComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MediaType]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MediaType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MediaType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Team]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Team](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_TeamType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeId] [int] NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](100) NULL,
	[UserName] [varchar](100) NULL,
	[Password] [varchar](10) NULL,
	[EmailId] [varchar](50) NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserType]    Script Date: 2/6/2014 8:23:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserTypeTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_EventType] FOREIGN KEY([TypeId])
REFERENCES [dbo].[EventType] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_EventType]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_TeamHomeTeamId] FOREIGN KEY([HomeTeamId])
REFERENCES [dbo].[Team] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_TeamHomeTeamId]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_User_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_User_CreatedBy]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_UserHostId] FOREIGN KEY([HostId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_UserHostId]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_UserModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_UserModifiedBy]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_VisitorTeam] FOREIGN KEY([VisitorTeamId])
REFERENCES [dbo].[Team] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_VisitorTeam]
GO
ALTER TABLE [dbo].[EventAddress]  WITH CHECK ADD  CONSTRAINT [FK_EventAddress_CityStateZip] FOREIGN KEY([CityId])
REFERENCES [dbo].[CityStateZip] ([Id])
GO
ALTER TABLE [dbo].[EventAddress] CHECK CONSTRAINT [FK_EventAddress_CityStateZip]
GO
ALTER TABLE [dbo].[EventAddress]  WITH CHECK ADD  CONSTRAINT [FK_EventAddress_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([Id])
GO
ALTER TABLE [dbo].[EventAddress] CHECK CONSTRAINT [FK_EventAddress_Event]
GO
ALTER TABLE [dbo].[EventComment]  WITH CHECK ADD  CONSTRAINT [FK_EventComment_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([Id])
GO
ALTER TABLE [dbo].[EventComment] CHECK CONSTRAINT [FK_EventComment_Event]
GO
ALTER TABLE [dbo].[EventComment]  WITH CHECK ADD  CONSTRAINT [FK_EventComment_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EventComment] CHECK CONSTRAINT [FK_EventComment_User]
GO
ALTER TABLE [dbo].[EventComment]  WITH CHECK ADD  CONSTRAINT [FK_EventComment_UserCreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EventComment] CHECK CONSTRAINT [FK_EventComment_UserCreatedBy]
GO
ALTER TABLE [dbo].[EventComment]  WITH CHECK ADD  CONSTRAINT [FK_EventComment_UserModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EventComment] CHECK CONSTRAINT [FK_EventComment_UserModifiedBy]
GO
ALTER TABLE [dbo].[EventMedia]  WITH CHECK ADD  CONSTRAINT [FK_EventMedia_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([Id])
GO
ALTER TABLE [dbo].[EventMedia] CHECK CONSTRAINT [FK_EventMedia_Event]
GO
ALTER TABLE [dbo].[EventMedia]  WITH CHECK ADD  CONSTRAINT [FK_EventMedia_MediaType] FOREIGN KEY([MediaTypeId])
REFERENCES [dbo].[MediaType] ([Id])
GO
ALTER TABLE [dbo].[EventMedia] CHECK CONSTRAINT [FK_EventMedia_MediaType]
GO
ALTER TABLE [dbo].[EventMedia]  WITH CHECK ADD  CONSTRAINT [FK_EventMedia_UserCreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EventMedia] CHECK CONSTRAINT [FK_EventMedia_UserCreatedBy]
GO
ALTER TABLE [dbo].[EventMedia]  WITH CHECK ADD  CONSTRAINT [FK_EventMedia_UserModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EventMedia] CHECK CONSTRAINT [FK_EventMedia_UserModifiedBy]
GO
ALTER TABLE [dbo].[MediaComment]  WITH CHECK ADD  CONSTRAINT [FK_MediaComment_EventMedia] FOREIGN KEY([MediaId])
REFERENCES [dbo].[EventMedia] ([Id])
GO
ALTER TABLE [dbo].[MediaComment] CHECK CONSTRAINT [FK_MediaComment_EventMedia]
GO
ALTER TABLE [dbo].[MediaComment]  WITH CHECK ADD  CONSTRAINT [FK_MediaComment_UserCreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[MediaComment] CHECK CONSTRAINT [FK_MediaComment_UserCreatedBy]
GO
ALTER TABLE [dbo].[MediaComment]  WITH CHECK ADD  CONSTRAINT [FK_MediaComment_UserModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[MediaComment] CHECK CONSTRAINT [FK_MediaComment_UserModifiedBy]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_User] FOREIGN KEY([Id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_User]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserType] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserType] ([Id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserType]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserTypeTable] FOREIGN KEY([ParentId])
REFERENCES [dbo].[UserType] ([Id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserTypeTable]
GO
